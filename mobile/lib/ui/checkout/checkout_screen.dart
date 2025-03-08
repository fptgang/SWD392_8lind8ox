import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/checkout/checkout_bloc.dart';
import 'package:mobile/blocs/checkout/checkout_event.dart';
import 'package:mobile/blocs/checkout/checkout_state.dart';
import 'package:mobile/blocs/promotion/promotion_bloc.dart';
import 'package:mobile/blocs/shipping_info/shipping_info_bloc.dart';
import 'package:mobile/blocs/shipping_info/shipping_info_event.dart';
import 'package:mobile/blocs/shipping_info/shipping_info_state.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/cubit/cart_cubit/cart_state.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/di/injection.dart';
import 'package:mobile/enum/enum.dart';
import 'package:mobile/ui/checkout/widget/address_section.dart';
import 'package:mobile/ui/checkout/widget/order_summary.dart';
import 'package:mobile/ui/checkout/widget/payment_option.dart';
import 'package:mobile/ui/checkout/widget/product_section.dart';
import 'package:mobile/ui/checkout/widget/promotion_section.dart';
import 'package:mobile/ui/checkout/widget/shipping_method.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/models/voucher_model.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutBloc = getIt<CheckoutBloc>();
    final cartCubit = getIt<CartCubit>();
    final promotionBloc = getIt<PromotionBloc>();
    final shippingInfoBloc = getIt<ShippingInfoBloc>();
    
    // Trigger loading of shipping info immediately
    shippingInfoBloc.add(GetShippingInfoById(1));

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cartCubit),
        BlocProvider(create: (context) => checkoutBloc),
        BlocProvider.value(value: promotionBloc),
        BlocProvider.value(value: shippingInfoBloc),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Thanh toán',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, checkoutState) {
            // Handle successful checkout
            if (checkoutState.loading == false && checkoutState.error == null && checkoutState.orders != null) {
              // Clear cart
              context.read<CartCubit>().clearCart();
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              
              // Navigate back to home
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
            
            // Handle checkout failure
            if (checkoutState.loading == false && checkoutState.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order failed: ${checkoutState.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, checkoutState) {
            // Show loader for processing checkout
            if (checkoutState.loading == true) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing your order...'),
                  ],
                ),
              );
            }
            
            return BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                // Check if we have selected items
                if (cartState.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Your cart is empty',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add items to your cart to checkout',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: const Text('Continue Shopping'),
                        ),
                      ],
                    ),
                  );
                }
                
                return _CheckoutForm(
                  cartState: cartState,
                  checkoutState: checkoutState,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CheckoutForm extends StatefulWidget {
  final CartState cartState;
  final CheckoutState checkoutState;

  const _CheckoutForm({
    required this.cartState,
    required this.checkoutState,
  });

  @override
  State<_CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<_CheckoutForm> {
  PaymentMethod? _selectedPaymentMethod;
  PromotionModel? _selectedVoucher;
  bool _termsAccepted = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    // Set default payment method
    _selectedPaymentMethod = PaymentMethod.PAYPAL;
  }
  
  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    final discount = _calculateDiscount();
    final shipping = _calculateShipping();
    final total = subtotal + shipping - discount;
    
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _buildAddressSection(),
          _buildProductSection(context, widget.cartState),
          buildShippingMethod(),
          buildPromotionalSection(
            context: context,
            selectedVoucher: _selectedVoucher,
            onVoucherSelected: (voucher) {
              setState(() {
                _selectedVoucher = voucher;
              });
            },
          ),
          _buildPaymentMethods(),
          _buildOrderSummary(subtotal, shipping, discount, total),
          _buildTermsAndConditionsCheckbox(),
          _buildPlaceOrderButton(total),
        ],
      ),
    );
  }
  
  Widget _buildAddressSection() {
    return BlocBuilder<ShippingInfoBloc, ShippingInfoState>(
      builder: (context, state) {
        if (state is ShippingInfoLoadingState && state.isLoading) {
          return Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ShippingInfoLoadingState && state.error != null) {
          return Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shipping Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading address: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<ShippingInfoBloc>().add(GetShippingInfoById(1));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is ShippingInfoDataState && state.shippingInfo != null) {
          return buildAddressSection();
        } else {
          return Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shipping Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No address found. Please add a shipping address.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to add address screen
                    // This would be implemented based on your navigation setup
                  },
                  child: const Text('Add Address'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
  
  Widget _buildPaymentMethods() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          buildPaymentOption(
            title: 'PayPal',
            icon: Icon(Icons.payment, color: Colors.blue[700]),
            selected: _selectedPaymentMethod == PaymentMethod.PAYPAL,
            onTap: () {
              setState(() {
                _selectedPaymentMethod = PaymentMethod.PAYPAL;
              });
              context.read<CheckoutBloc>().add(
                SelectPaymentMethod(_selectedPaymentMethod.toString()),
              );
            },
          ),
          buildPaymentOption(
            title: 'VN Pay',
            icon: Icon(Icons.account_balance, color: Colors.red[700]),
            selected: _selectedPaymentMethod == PaymentMethod.VNPAY,
            onTap: () {
              setState(() {
                _selectedPaymentMethod = PaymentMethod.VNPAY;
              });
              context.read<CheckoutBloc>().add(
                SelectPaymentMethod(_selectedPaymentMethod.toString()),
              );
            },
          ),
          if (_selectedPaymentMethod == null)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Please select a payment method',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  double _calculateSubtotal() {
    // Ensure safe access to item properties
    return widget.cartState.items.fold(
      0.0, 
      (sum, item) {
        // Cast to CartItem since CartState likely uses the legacy CartItem class
        final cartItem = item as CartItemModel;
        return sum + (cartItem.price * cartItem.quantity);
      }
    );
  }
  
  double _calculateDiscount() {
    if (_selectedVoucher == null) return 0.0;
    
    final subtotal = _calculateSubtotal();
    final discountRate = _selectedVoucher!.discountRate ?? 0.0;
    
    // Apply the discount rate to the subtotal
    return subtotal * discountRate;
  }
  
  double _calculateShipping() {
    // This could be implemented with more complex logic
    // For example, based on weight, distance, or shipping method
    final itemCount = widget.cartState.items.fold(
      0, 
      (sum, item) => sum + (item as CartItemModel).quantity,
    );
    
    // Base shipping fee
    double shippingFee = 5.0;
    
    // Add $1 for each additional item beyond the first
    if (itemCount > 1) {
      shippingFee += (itemCount - 1) * 1.0;
    }
    
    return shippingFee;
  }
  
  Widget _buildOrderSummary(double subtotal, double shipping, double discount, double total) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow('Shipping Fee', '\$${shipping.toStringAsFixed(2)}'),
          if (discount > 0) 
            _buildSummaryRow('Discount', '-\$${discount.toStringAsFixed(2)}'),
          const Divider(height: 24),
          _buildSummaryRow(
            'Total', 
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTermsAndConditionsCheckbox() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Checkbox(
            value: _termsAccepted,
            onChanged: (value) {
              setState(() {
                _termsAccepted = value ?? false;
              });
            },
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlaceOrderButton(double total) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _selectedPaymentMethod == null || !_termsAccepted
                  ? null  // Disable button if conditions not met
                  : _confirmOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                disabledBackgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Place Order - \$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (!_termsAccepted)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Please accept the terms and conditions',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
  
  void _confirmOrder() {
    // Validate checkout form
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: const Text('Are you sure you want to place this order?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _placeOrder();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
  
  void _placeOrder() {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }
    
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }
    
    final checkoutBloc = context.read<CheckoutBloc>();
    
    final List<OrderDetailModel> orderDetails = widget.cartState.items.map((item) =>
      OrderDetailModel(
        orderDetailId: 0,
        orderId: 0,
        quantity: (item as CartItemModel).quantity,
        originalPrice: (item as CartItemModel).price,
        checkoutPrice: (item as CartItemModel).price,
        sku: StockKeepingUnitModel(
          skuId: (item as CartItemModel).skuId,
          name: (item as CartItemModel).productName,
          price: (item as CartItemModel).price,
        ),
      )
    ).toList();
    
    // Create an OrderModel for the checkout
    final orderModel = OrderModel(
      orderId: 0,  // Will be assigned by server
      orderDetails: orderDetails,
      shippingInfo: widget.checkoutState.shippingInfo,
      voucher: _selectedVoucher != null ? VoucherModel(
        voucherId: _selectedVoucher!.campaignId,
        discountRate: _selectedVoucher!.discountRate,
      ) : null,
      checkoutPrice: _calculateSubtotal() - _calculateDiscount(),
      originalPrice: _calculateSubtotal(),
      createdAt: DateTime.now(),
    );
    
    // Trigger checkout event with the order model
    checkoutBloc.add(Checkout(
      orders: orderModel,
      shippingInfo: widget.checkoutState.shippingInfo,
      paymentMethod: _selectedPaymentMethod.toString(),
    ));
  }
  
  Widget _buildProductSection(BuildContext context, CartState cartState) {
    final selectedItems = cartState.items;
    
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Products',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...selectedItems.map((item) => _buildCheckoutItemRow(item as CartItemModel)),
        ],
      ),
    );
  }
  
  Widget _buildCheckoutItemRow(CartItemModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Quantity: ${item.quantity}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            "\$${(item.price * item.quantity).toStringAsFixed(2)}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.black : Colors.grey.shade600,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.red : Colors.black,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
