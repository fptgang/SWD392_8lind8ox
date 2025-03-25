import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/app/blocs/cart/cart_event.dart';
import 'package:mobile/app/blocs/cart/cart_global_bloc.dart';
import 'package:mobile/app/blocs/cart/cart_state.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/order_response_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:mobile/data/repositories/voucher_repository.dart';
import 'package:mobile/feature/payment/vnpay_service.dart';
import 'package:mobile/feature/profile/blocs/account/account_bloc.dart';
import 'package:mobile/feature/profile/blocs/account/account_event.dart';
import 'package:mobile/feature/profile/blocs/account/account_state.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_bloc.dart';
import 'package:mobile/feature/shipping/blocs/shipping_address/shipping_info_event.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:openapi/api.dart' as openapi;

import 'components/address_section.dart';
import 'components/order_items_section.dart';
import 'components/payment_method_section.dart';
import 'components/voucher_section.dart';
import 'components/order_summary_section.dart';

// Use the same VoucherDto and CartDtoPaymentMethodEnum from components

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CartPaymentMethodEnum paymentMethod = CartPaymentMethodEnum.VNPAY;
  bool isProcessingOrder = false;
  OrderResponseModel? orderResponse;

  final CartGlobalBloc _cartBloc = getIt<CartGlobalBloc>();
  final ShippingInfoRepository _shippingInfoRepository =
      getIt<ShippingInfoRepository>();
  final AccountBloc _accountBloc = getIt<AccountBloc>();

  @override
  void initState() {
    super.initState();
    _cartBloc.add(LoadCart());
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    try {
      // Load account data to get current user's info including default shipping address
      _accountBloc.add(const LoadAccount(forceRefresh: true));

      // Listen for account loaded state
      _accountBloc.stream.listen((state) {
        if (state is AccountLoaded && mounted) {
          // If account has a default shipping address and cart doesn't have shipping info set
          if (state.defaultShippingAddress != null &&
              _cartBloc.state.shippingInfo == null) {
            // Use the account's default shipping address
            _cartBloc.add(SetShippingInfo(state.defaultShippingAddress!));
          } else if (state.defaultShippingAddress == null) {
            // If no default address, load user's shipping addresses
            _loadShippingAddresses();
          }
        }
      });
    } catch (e) {
      debugPrint('Error loading account data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load account data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadShippingAddresses() async {
    try {
      final response = await _shippingInfoRepository.getShippingInfos();
      if (mounted && response.content.isNotEmpty) {
        // If we already have shipping info in cart, don't override it
        if (_cartBloc.state.shippingInfo == null) {
          final firstAddress = response.content.first;
          _cartBloc.add(SetShippingInfo(firstAddress));
        }
      }
    } catch (e) {
      debugPrint('Error loading shipping addresses: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load shipping addresses: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Handle shipping info selection
  void onSelectShippingInfo(int id) async {
    try {
      final shippingInfo =
          await _shippingInfoRepository.getShippingInfoById(id);
      _cartBloc.add(SetShippingInfo(shippingInfo));
    } catch (e) {
      debugPrint('Error selecting shipping address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select shipping address: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Handle voucher selection
  Future<void> onSelectVoucher(VoucherDto voucherDto) async {
    try {
      if (voucherDto.voucherId != null) {
        final voucher = await getIt<VoucherRepository>()
            .getVoucherById(voucherDto.voucherId!);
        _cartBloc.add(SetVoucher(voucher));
      }
    } catch (e) {
      debugPrint('Error fetching voucher details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to apply voucher: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Handle voucher removal
  void onRemoveVoucher() {
    _cartBloc.add(SetVoucher(VoucherModel()));
  }

  // Handle payment method selection
  void onSelectPaymentMethod(CartDtoPaymentMethodEnum method) {
    CartPaymentMethodEnum mappedPaymentMethod;

    switch (method) {
      case CartDtoPaymentMethodEnum.INTERNAL_WALLET:
        mappedPaymentMethod = CartPaymentMethodEnum.INTERNAL_WALLET;
        break;
      case CartDtoPaymentMethodEnum.PAYPAL:
        mappedPaymentMethod = CartPaymentMethodEnum.PAYPAL;
        break;
      case CartDtoPaymentMethodEnum.VNPAY:
        mappedPaymentMethod = CartPaymentMethodEnum.VNPAY;
        break;
      default:
        mappedPaymentMethod = CartPaymentMethodEnum.VNPAY;
    }

    setState(() {
      paymentMethod = mappedPaymentMethod;
    });
  }

  // Handle place order
  Future<void> placeOrder() async {
    if (_cartBloc.state.shippingInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a shipping address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_cartBloc.state.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isProcessingOrder = true;
    });

    try {
      // Use CartGlobalBloc to place order
      String paymentMethodString;
      switch (paymentMethod) {
        case CartPaymentMethodEnum.INTERNAL_WALLET:
          paymentMethodString = 'INTERNAL_WALLET';
          break;
        case CartPaymentMethodEnum.PAYPAL:
          paymentMethodString = 'PAYPAL';
          break;
        case CartPaymentMethodEnum.VNPAY:
        default:
          paymentMethodString = 'VNPAY';
      }

      _cartBloc.add(PlaceOrder(paymentMethod: paymentMethodString));

      // Listen for completion in the BlocListener
    } catch (e) {
      debugPrint('Error placing order: $e');
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isProcessingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cartBloc,
      child: BlocConsumer<CartGlobalBloc, CartState>(
        listener: (context, state) {
          // Handle loading state
          if (state.isLoading != isProcessingOrder) {
            setState(() {
              isProcessingOrder = state.isLoading;
            });
          }

          // Handle errors
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
              ),
            );
          }

          // Handle order response
          if (state.orderResponse != null &&
              (orderResponse == null ||
                  orderResponse?.order?.orderId !=
                      state.orderResponse?.order?.orderId)) {
            setState(() {
              orderResponse = state.orderResponse;
            });

            // Process payment for VNPAY
            if (!state.isLoading &&
                state.orderResponse!.paymentRedirectUrl != null &&
                paymentMethod == CartPaymentMethodEnum.VNPAY) {
              _handlePaymentRedirect(state.orderResponse!);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Checkout'),
              centerTitle: true,
            ),
            body: state.items.isEmpty
                ? _buildEmptyCart()
                : _buildCheckoutContent(state),
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to home or products page
              Navigator.of(context).pop();
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutContent(CartState cartState) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 800;

      if (isMobile) {
        return _buildMobileLayout(cartState);
      } else {
        return _buildDesktopLayout(cartState);
      }
    });
  }

  Widget _buildMobileLayout(CartState cartState) {
    // Convert CartItemModel to map format for OrderItemsSection
    final List<Map<String, dynamic>> displayItems = cartState.items
        .map((item) => {
              'id': item.id,
              'name': item.productName,
              'skuName': '', // We don't have this in CartItemModel
              'price': item.price,
              'originalPrice':
                  item.price, // Use same price as no original price in model
              'quantity': item.quantity,
              'imageUrl': item.image,
              'skuId': item.skuId,
            })
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderItemsSection(items: displayItems),
          const SizedBox(height: 16),
          VoucherSection(
            selectedVoucher: cartState.voucher != null
                ? VoucherDto(
                    voucherId: cartState.voucher!.voucherId,
                    code: cartState.voucher!.code,
                    discountRate: cartState.voucher!.discountRate,
                    limitAmount: cartState.voucher!.limitAmount,
                    expiredAt: cartState.voucher!.expiredAt)
                : null,
            onSelectVoucher: onSelectVoucher,
            onRemoveVoucher: onRemoveVoucher,
          ),
          const SizedBox(height: 16),
          AddressSection(
            selectedAddressId: cartState.shippingInfo?.shippingInfoId,
            onSelectAddress: onSelectShippingInfo,
          ),
          const SizedBox(height: 16),
          PaymentMethodSection(
            selectedPaymentMethod: _mapToComponentsEnum(paymentMethod),
            onSelectPaymentMethod: onSelectPaymentMethod,
            walletBalance: 50.0, // Example balance
            finalTotal: cartState.finalTotal,
          ),
          const SizedBox(height: 16),
          OrderSummarySection(
            subtotal: cartState.total,
            voucherDiscount: cartState.voucherDiscount,
            finalTotal: cartState.finalTotal,
            isProcessingOrder: isProcessingOrder,
            canPlaceOrder: cartState.shippingInfo != null,
            onPlaceOrder: placeOrder,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(CartState cartState) {
    // Convert CartItemModel to map format for OrderItemsSection
    final List<Map<String, dynamic>> displayItems = cartState.items
        .map((item) => {
              'id': item.id,
              'name': item.productName,
              'skuName': '', // We don't have this in CartItemModel
              'price': item.price,
              'originalPrice':
                  item.price, // Use same price as no original price in model
              'quantity': item.quantity,
              'imageUrl': item.image,
              'skuId': item.skuId,
            })
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column - 2/3 width
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderItemsSection(items: displayItems),
                  const SizedBox(height: 24),
                  VoucherSection(
                    selectedVoucher: cartState.voucher != null
                        ? VoucherDto(
                            voucherId: cartState.voucher!.voucherId,
                            code: cartState.voucher!.code,
                            discountRate: cartState.voucher!.discountRate,
                            limitAmount: cartState.voucher!.limitAmount,
                            expiredAt: cartState.voucher!.expiredAt)
                        : null,
                    onSelectVoucher: onSelectVoucher,
                    onRemoveVoucher: onRemoveVoucher,
                  ),
                  const SizedBox(height: 24),
                  AddressSection(
                    selectedAddressId: cartState.shippingInfo?.shippingInfoId,
                    onSelectAddress: onSelectShippingInfo,
                  ),
                  const SizedBox(height: 24),
                  PaymentMethodSection(
                    selectedPaymentMethod: _mapToComponentsEnum(paymentMethod),
                    onSelectPaymentMethod: onSelectPaymentMethod,
                    walletBalance: 50.0, // Example balance
                    finalTotal: cartState.finalTotal,
                  ),
                ],
              ),
            ),
          ),

          // Right column - 1/3 width
          Expanded(
            child: OrderSummarySection(
              subtotal: cartState.total,
              voucherDiscount: cartState.voucherDiscount,
              finalTotal: cartState.finalTotal,
              isProcessingOrder: isProcessingOrder,
              canPlaceOrder: cartState.shippingInfo != null,
              onPlaceOrder: placeOrder,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to map between enum types
  CartDtoPaymentMethodEnum _mapToComponentsEnum(CartPaymentMethodEnum method) {
    switch (method) {
      case CartPaymentMethodEnum.INTERNAL_WALLET:
        return CartDtoPaymentMethodEnum.INTERNAL_WALLET;
      case CartPaymentMethodEnum.PAYPAL:
        return CartDtoPaymentMethodEnum.PAYPAL;
      case CartPaymentMethodEnum.VNPAY:
        return CartDtoPaymentMethodEnum.VNPAY;
      default:
        return CartDtoPaymentMethodEnum.VNPAY;
    }
  }

  // Handle payment redirect for external payment methods like VNPAY
  Future<void> _handlePaymentRedirect(OrderResponseModel response) async {
    if (response.paymentRedirectUrl == null ||
        response.paymentRedirectUrl!.isEmpty) {
      debugPrint('No payment URL provided for redirection');
      return;
    }

    try {
      debugPrint(
          'Opening WebView with payment URL: ${response.paymentRedirectUrl}');

      // Use the VNPayService to open a WebView with the payment URL
      final paymentSuccess = await VNPayService.processPayment(
        context,
        orderResponse: response,
      );

      if (paymentSuccess) {
        // Payment successful, navigate to order confirmation screen
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment completed successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to order confirmation screen
          Navigator.of(context)
              .pushReplacementNamed('/order-complete', arguments: {
            'orderId': response.order?.orderId,
          });
        }
      } else {
        // Payment failed or canceled
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment was not completed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error processing payment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment processing error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
