import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/models/create_shipping_info_model.dart';
import 'package:mobile/feature/cart/cubits/cart_cubit.dart';
import 'package:mobile/feature/cart/cubits/cart_state.dart';
import 'package:mobile/feature/checkout/blocs/checkout_bloc.dart';
import 'package:mobile/feature/checkout/blocs/checkout_event.dart';
import 'package:mobile/feature/checkout/blocs/checkout_state.dart';
import 'package:mobile/feature/checkout/blocs/shipping_info/shipping_info_bloc.dart';
import 'package:mobile/feature/checkout/blocs/shipping_info/shipping_info_event.dart';
import 'package:mobile/feature/checkout/blocs/shipping_info/shipping_info_state.dart';
import 'package:mobile/feature/checkout/widget/address_section.dart';
import 'package:mobile/feature/checkout/widget/payment_option.dart';
import 'package:mobile/feature/checkout/widget/promotion_section.dart';
import 'package:mobile/feature/home/blocs/promotion/promotion_bloc.dart';
import 'package:mobile/utils/enum/enum.dart';

/// Main checkout screen
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutBloc = getIt<CheckoutBloc>();
    final cartCubit = getIt<CartCubit>();
    final promotionBloc = getIt<PromotionBloc>();
    final shippingInfoBloc = getIt<ShippingInfoBloc>();

    // Load shipping info for current user
    // final accountId = Hive.box('authentication').get('accountId');
    // debugPrint('Loading shipping info for accountId: $accountId');
    shippingInfoBloc.add(GetShippingInfos(0));

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
        body: _CheckoutScreenContent(),
      ),
    );
  }
}

/// Main content of the checkout screen with bloc listeners
class _CheckoutScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CheckoutBloc, CheckoutState>(
          listener: _handleCheckoutStateChanges,
        ),
        BlocListener<ShippingInfoBloc, ShippingInfoState>(
          listener: _handleShippingInfoStateChanges,
        ),
      ],
      child: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, checkoutState) {
          if (checkoutState.loading == true) {
            return _buildLoadingIndicator();
          }

          return BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              final selectedItems = cartState.items
                  .where((item) => cartState.selectedItemIds.contains(item.id))
                  .toList();

              if (selectedItems.isEmpty) {
                return _buildEmptyCartView(context);
              }

              final checkoutItems = _convertToCartItemModels(selectedItems);

              return _CheckoutFormContent(
                checkoutItems: checkoutItems,
                checkoutBloc: context.read<CheckoutBloc>(),
                shippingInfoBloc: context.read<ShippingInfoBloc>(),
              );
            },
          );
        },
      ),
    );
  }

  void _handleCheckoutStateChanges(BuildContext context, CheckoutState state) {
    if (state.loading == false && state.error == null && state.isOrderCreated) {
      _handleSuccessfulOrder(context);
    } else if (state.loading == false && state.error != null) {
      _handleOrderError(context, state.error!);
    }
  }

  void _handleSuccessfulOrder(BuildContext context) {
    context.read<CartCubit>().clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _handleOrderError(BuildContext context, String errorMessage) {
    String displayMessage = errorMessage;
    bool needsAddress = false;

    // Convert technical errors to user-friendly messages
    if (errorMessage.contains('Shipping information is required')) {
      displayMessage = 'Please add a shipping address';
      needsAddress = true;
    } else if (errorMessage.contains('Payment method is required')) {
      displayMessage = 'Please select a payment method';
    } else if (errorMessage.contains('No items in cart')) {
      displayMessage = 'Your cart is empty. Please add items to your cart';
    } else if (errorMessage
        .contains('ShippingInfo does not belong to account')) {
      displayMessage =
          'The shipping address does not belong to your account. Please add a new shipping address.';
      needsAddress = true;
    }

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order failed: $displayMessage'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: needsAddress ? 'Add Address' : 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (needsAddress) {
              _showAddAddressDialog(context);
            }
          },
        ),
      ),
    );
  }

  void _handleShippingInfoStateChanges(
      BuildContext context, ShippingInfoState state) {
    if (state is ShippingInfoLoadingState && state.isLoading) {
      // Do nothing, loading indicator already shown in UI
    } else if (state is ShippingInfoLoadingState && state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${state.error}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } else if (state is ShippingInfoDataState &&
        state.shippingInfo != null &&
        state.shippingInfo!.shippingInfoId != 1) {
      // Only show success message if it's not the initial load
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shipping address created successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildLoadingIndicator() {
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

  Widget _buildEmptyCartView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined,
              size: 64, color: Colors.grey),
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

  void _showAddAddressDialog(BuildContext context) {
    final shippingInfoBloc = context.read<ShippingInfoBloc>();
    ShippingAddressForm.show(context, shippingInfoBloc);
  }

  List<CartItemModel> _convertToCartItemModels(
      List<CartDisplayItem> displayItems) {
    return displayItems.map((item) => item.toCartItemModel()).toList();
  }
}

/// Shipping address form dialog
class ShippingAddressForm {
  static void show(BuildContext context, ShippingInfoBloc shippingInfoBloc) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final wardController = TextEditingController();
    final districtController = TextEditingController();
    final cityController = TextEditingController();
    final phoneNumberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: getColorSkin().white,
          title: const Text('Add Shipping Address'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name*',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address*',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: wardController,
                  decoration: const InputDecoration(
                    labelText: 'Ward*',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: districtController,
                  decoration: const InputDecoration(
                    labelText: 'District*',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'City*',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number*',
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  Text('Cancel', style: TextStyle(color: getColorSkin().black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.red)),
              ),
              onPressed: () => _handleFormSubmit(
                context,
                shippingInfoBloc,
                nameController.text,
                addressController.text,
                wardController.text,
                districtController.text,
                cityController.text,
                phoneNumberController.text,
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  static void _handleFormSubmit(
    BuildContext context,
    ShippingInfoBloc shippingInfoBloc,
    String name,
    String address,
    String ward,
    String district,
    String city,
    String phoneNumber,
  ) {
    // Validate all fields
    if (name.isEmpty ||
        address.isEmpty ||
        ward.isEmpty ||
        district.isEmpty ||
        city.isEmpty ||
        phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Creating shipping address...'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);

    try {
      final CreateShippingInfoModel model = CreateShippingInfoModel(
        name: name,
        address: address,
        ward: ward,
        district: district,
        city: city,
        phoneNumber: phoneNumber,
      );

      debugPrint('Shipping info DTO from checkout screen: ${model.toString()}');
      shippingInfoBloc.add(CreateShippingInfo(model));
    } catch (e) {
      debugPrint('Exception setting DTO fields: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating shipping address: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}

/// Main form content for the checkout process
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
          return _buildLoadingAddressSection();
        } else if (state is ShippingInfoLoadingState && state.error != null) {
          return _buildErrorAddressSection(context, state.error!);
        } else if (state is ShippingInfoDataState) {
          return buildAddressSection();
        } else {
          return _buildEmptyAddressSection(context);
        }
      },
    );
  }

  Widget _buildLoadingAddressSection() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(color: getColorSkin().primaryRed950),
      ),
    );
  }

  Widget _buildErrorAddressSection(BuildContext context, String error) {
    final bool noShippingInfo = error.contains("Cannot get shipping info") ||
        error.contains("not found");

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
            noShippingInfo
                ? 'You don\'t have a shipping address yet. Please add one to continue.'
                : 'Error loading address: $error',
            style: TextStyle(
              color: noShippingInfo ? Colors.orange[800] : Colors.red,
              fontWeight: noShippingInfo ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  ShippingAddressForm.show(context, shippingInfoBloc),
              style: ElevatedButton.styleFrom(
                backgroundColor: getColorSkin().white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                noShippingInfo ? 'Add Shipping Address' : 'Add New Address',
                style: TextStyle(fontSize: 16, color: getColorSkin().black),
              ),
            ),
          ),
          if (!noShippingInfo) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final accountId = Hive.box('authentication').get('accountId');
                debugPrint(
                    'Retrying to load shipping info for account ID: $accountId');
                shippingInfoBloc.add(GetShippingInfoById(accountId));
              },
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyAddressSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
              color: Colors.orange[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[800]),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'No shipping address found',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please add a shipping address to continue with your order.',
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () =>
                  ShippingAddressForm.show(context, shippingInfoBloc),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add Shipping Address',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
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
    return checkoutItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
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

  Widget _buildOrderSummary(BuildContext context, double subtotal,
      double shipping, double discount, double total) {
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
              _buildSummaryRow(
                  'Shipping Fee', '\$${shipping.toStringAsFixed(2)}'),
              if (discount > 0)
                _buildSummaryRow(
                    'Discount', '-\$${discount.toStringAsFixed(2)}'),
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
                        style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold),
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
        final canProceed =
            state.selectedPaymentMethod != null && state.termsAccepted;

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
    if (!(checkoutBloc.formKey.currentState?.validate() ?? false)) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: getColorSkin().white,
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
    final shippingInfoState = shippingInfoBloc.state;

    if (!_validateShippingInfo(context, shippingInfoState)) return;
    final shippingInfoId = (shippingInfoState as ShippingInfoDataState)
        .shippingInfo!
        .shippingInfoId;

    if (checkoutState.selectedPaymentMethod == null) {
      _showError(context, 'Please select a payment method');
      return;
    }

    if (!checkoutState.termsAccepted) {
      _showError(context, 'Please accept the terms and conditions');
      return;
    }
    if (!_validateCartItems(context)) return;

    final cartModel = CartModel(
      items: checkoutItems,
      paymentMethod: checkoutBloc
          .mapPaymentMethodToEnum(checkoutState.selectedPaymentMethod),
      voucherId: checkoutState.selectedVoucher?.campaignId,
      shippingInfoId: shippingInfoId,
    );

    debugPrint('Cart model for checkout: $cartModel');

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Processing your order...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Request order creation
    checkoutBloc.add(Checkout(
      cartModelToCheckout: cartModel,
    ));
  }

  bool _validateShippingInfo(BuildContext context, ShippingInfoState state) {
    if (state is! ShippingInfoDataState || state.shippingInfo == null) {
      _showError(context,
          'Shipping information is required. Please add a shipping address.');
      return false;
    }
    return true;
  }

  bool _validateCartItems(BuildContext context) {
    if (checkoutItems.isEmpty) {
      _showError(context, 'Your cart is empty. Please add items to checkout.');
      return false;
    }

    if (checkoutItems.any((item) => item.skuId == null)) {
      _showError(
          context, 'Some items in your cart are missing required information.');
      return false;
    }

    return true;
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
          ...checkoutItems.map((item) => _buildCheckoutItemRow(item)),
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
