import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import 'package:mobile/di/injection.dart';
import 'package:mobile/enum/enum.dart';
import 'package:mobile/ui/checkout/widget/address_section.dart';
import 'package:mobile/ui/checkout/widget/payment_option.dart';
import 'package:mobile/ui/checkout/widget/promotion_section.dart';
import 'package:mobile/ui/checkout/widget/shipping_method.dart';

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
        BlocProvider.value(value: checkoutBloc),
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
            if (checkoutState.loading == false && checkoutState.error == null && checkoutState.isOrderCreated) {
              context.read<CartCubit>().clearCart();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
            
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
                // Filter items to only include selected ones
                final selectedItems = cartState.items
                    .where((item) => cartState.selectedItemIds.contains(item.id))
                    .toList();
                
                if (selectedItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No items selected for checkout',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Please select items in your cart to checkout',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: const Text('Back to Cart'),
                        ),
                      ],
                    ),
                  );
                }
                
                final checkoutItems = _convertToCartItemModels(selectedItems);
                
                return _CheckoutFormContent(
                  checkoutItems: checkoutItems,
                  checkoutBloc: checkoutBloc,
                  shippingInfoBloc: shippingInfoBloc,
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<CartItemModel> _convertToCartItemModels(List<CartDisplayItem> displayItems) {
    return displayItems.map((item) => item.toCartItemModel()).toList();
  }
}

class _CheckoutFormContent extends StatelessWidget {
  final List<CartItemModel> checkoutItems;
  final CheckoutBloc checkoutBloc;
  final ShippingInfoBloc shippingInfoBloc;

  const _CheckoutFormContent({
    required this.checkoutItems,
    required this.checkoutBloc,
    required this.shippingInfoBloc,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate totals
    final subtotal = _calculateSubtotal();
    final discount = _calculateDiscount(context);
    final shipping = _calculateShipping();
    final total = subtotal + shipping - discount;
    
    return Form(
      key: checkoutBloc.formKey,
      child: ListView(
        children: [
          _buildAddressSection(context),
          _buildProductSection(context),
          buildShippingMethod(),
          _buildPromotionalSection(context),
          _buildPaymentMethods(context),
          _buildOrderSummary(context, subtotal, shipping, discount, total),
          _buildTermsAndConditionsCheckbox(context),
          _buildPlaceOrderButton(context, total),
        ],
      ),
    );
  }
  
  Widget _buildAddressSection(BuildContext context) {
    return BlocBuilder<ShippingInfoBloc, ShippingInfoState>(
      bloc: shippingInfoBloc,
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
                    shippingInfoBloc.add(GetShippingInfoById(1));
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
  
  Widget _buildPromotionalSection(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      bloc: checkoutBloc,
      builder: (context, state) {
        return buildPromotionalSection(
          context: context,
          selectedVoucher: state.selectedVoucher,
          onVoucherSelected: (voucher) {
            checkoutBloc.add(UpdateSelectedVoucher(voucher));
          },
        );
      },
    );
  }
  
  Widget _buildPaymentMethods(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      bloc: checkoutBloc,
      builder: (context, state) {
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
                selected: state.selectedPaymentMethod == PaymentMethod.PAYPAL,
                onTap: () {
                  checkoutBloc.add(
                    const SelectPaymentMethod('PAYPAL'),
                  );
                },
              ),
              buildPaymentOption(
                title: 'VN Pay',
                icon: Icon(Icons.account_balance, color: Colors.red[700]),
                selected: state.selectedPaymentMethod == PaymentMethod.VNPAY,
                onTap: () {
                  checkoutBloc.add(
                    const SelectPaymentMethod('VNPAY'),
                  );
                },
              ),
              if (state.selectedPaymentMethod == null)
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
      },
    );
  }

  double _calculateSubtotal() {
    // Use the checkoutItems (CartItemModel) list directly
    return checkoutItems.fold(
      0.0, 
      (sum, item) => sum + (item.price * item.quantity)
    );
  }
  
  double _calculateDiscount(BuildContext context) {
    final checkoutState = checkoutBloc.state;
    final selectedVoucher = checkoutState.selectedVoucher;
    
    if (selectedVoucher == null) return 0.0;
    
    final subtotal = _calculateSubtotal();
    final discountRate = selectedVoucher.discountRate ?? 0.0;
    
    // Apply the discount rate to the subtotal
    return subtotal * discountRate;
  }
  
  double _calculateShipping() {
    // This could be implemented with more complex logic
    // For example, based on weight, distance, or shipping method
    final itemCount = checkoutItems.fold(
      0, 
      (sum, item) => sum + item.quantity,
    );
    
    // Base shipping fee
    double shippingFee = 5.0;
    
    // Add $1 for each additional item beyond the first
    if (itemCount > 1) {
      shippingFee += (itemCount - 1) * 1.0;
    }
    
    return shippingFee;
  }
  
  Widget _buildOrderSummary(BuildContext context, double subtotal, double shipping, double discount, double total) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      bloc: checkoutBloc,
      builder: (context, state) {
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
      },
    );
  }
  
  Widget _buildTermsAndConditionsCheckbox(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      bloc: checkoutBloc,
      builder: (context, state) {
        return Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(
                value: state.termsAccepted,
                onChanged: (value) {
                  checkoutBloc.add(SetTermsAccepted(value ?? false));
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
      },
    );
  }
  
  Widget _buildPlaceOrderButton(BuildContext context, double total) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      bloc: checkoutBloc,
      builder: (context, state) {
        final canProceed = state.selectedPaymentMethod != null && state.termsAccepted;
        
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
                  onPressed: canProceed ? () => _confirmOrder(context) : null,
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
              if (!state.termsAccepted)
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
      },
    );
  }
  
  void _confirmOrder(BuildContext context) {
    // Validate checkout form
    if (!(checkoutBloc.formKey.currentState?.validate() ?? false)) {
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
                _placeOrder(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
  
  void _placeOrder(BuildContext context) {
    final checkoutState = checkoutBloc.state;
    
    // Get the shipping info ID from the ShippingInfoBloc state directly
    final shippingInfoState = shippingInfoBloc.state;
    
    int? shippingInfoId;
    
    if (shippingInfoState is ShippingInfoDataState && shippingInfoState.shippingInfo != null) {
      shippingInfoId = shippingInfoState.shippingInfo!.shippingInfoId;
    }
    
    // Check if shipping info is available
    if (shippingInfoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shipping information is required. Please add a shipping address.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Check if payment method is selected
    if (checkoutState.selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }
    
    // Check if terms are accepted
    if (!checkoutState.termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }
    
    debugPrint('Creating order with shipping ID: $shippingInfoId');

    final cartModel = CartModel(
      items: checkoutItems,
      paymentMethod: checkoutBloc.mapPaymentMethodToEnum(checkoutState.selectedPaymentMethod),
      voucherId: checkoutState.selectedVoucher?.campaignId,
      shippingInfoId: shippingInfoId,
    );
    
    debugPrint('Cart model for checkout: $cartModel');

    checkoutBloc.add(Checkout(cartModelToCheckout: cartModel));
  }
  
  Widget _buildProductSection(BuildContext context) {
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
          ...checkoutItems.map((item) => _buildCheckoutItemRow(item)).toList(),
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
