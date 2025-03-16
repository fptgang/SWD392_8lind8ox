import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:mobile/data/repositories/voucher_repository.dart';
import 'package:mobile/feature/checkout/blocs/checkout_event.dart';
import 'package:mobile/feature/checkout/blocs/checkout_state.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:openapi/api.dart';
@injectable
@lazySingleton
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRepository orderRepository;
  final VoucherRepository? voucherRepository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DefaultApi _apiService = getIt<DefaultApi>();

  CheckoutBloc(
      this.voucherRepository, {
        required this.orderRepository,
      }) : super(const CheckoutState()) {
    on<InitializeCheckout>(_onInitializeCheckout);
    on<Checkout>(_onCheckout);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<OrderFetched>(_onOrderFetched);
    on<CalculateTotalPrice>(_onCalculateTotalPrice);
    on<ApplyVoucher>(_onApplyVoucher);
    on<SetTermsAccepted>(_onSetTermsAccepted);
    on<UpdateSelectedVoucher>(_onUpdateSelectedVoucher);
    on<ValidateAndPlaceOrder>(_onValidateAndPlaceOrder);
    on<ClearCheckoutError>(_onClearCheckoutError);
  }

  void _onInitializeCheckout(
      InitializeCheckout event,
      Emitter<CheckoutState> emit,
      ) {
    // Initialize the checkout screen with default values
    emit(CheckoutState(
      loading: false,
      error: null,
      selectedPaymentMethod: null,
      selectedVoucher: null,
      termsAccepted: false,
      isOrderCreated: false,
    ));
  }

  void _onClearCheckoutError(
      ClearCheckoutError event,
      Emitter<CheckoutState> emit,
      ) {
    emit(state.copyWith(error: null));
  }

  void _onSetTermsAccepted(
      SetTermsAccepted event,
      Emitter<CheckoutState> emit,
      ) {
    emit(state.copyWith(termsAccepted: event.accepted));
  }

  void _onUpdateSelectedVoucher(
      UpdateSelectedVoucher event,
      Emitter<CheckoutState> emit,
      ) {
    emit(state.copyWith(selectedVoucher: event.voucher));
  }

  Future<void> _onOrderFetched(
      OrderFetched event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      // Fetch the order details from the repository
      final order = await orderRepository.getOrderById(event.orderId);

      emit(state.copyWith(
        isLoading: false,
        // You might want to store the order in another state property
      ));
    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
        isLoading: false,
      ));
    }
  }

  void _onCalculateTotalPrice(
      CalculateTotalPrice event,
      Emitter<CheckoutState> emit,
      ) {
    if (state.cartModelToCheckout == null) return;

    // Here you would calculate the total price for all items in the cart
    // For now, we'll just ensure the state is consistent
    emit(state.copyWith(cartModelToCheckout: state.cartModelToCheckout));
  }

  void _onSelectPaymentMethod(
      SelectPaymentMethod event,
      Emitter<CheckoutState> emit,
      ) {
    final paymentMethod = _stringToPaymentMethod(event.paymentMethod);
    emit(state.copyWith(selectedPaymentMethod: paymentMethod));

    if (state.cartModelToCheckout != null) {
      // Update the cart model with the selected payment method
      final updatedCart = state.cartModelToCheckout!.copyWith(
        paymentMethod: mapPaymentMethodToEnum(paymentMethod),
      );

      emit(state.copyWith(cartModelToCheckout: updatedCart));
    }
  }

  void _onValidateAndPlaceOrder(
      ValidateAndPlaceOrder event,
      Emitter<CheckoutState> emit,
      ) {
    try {
      // Reset any previous errors
      emit(state.copyWith(error: null));

      // Validate shipping info
      if (event.shippingInfoId == null) {
        emit(state.copyWith(error: 'Please select a shipping address'));
        return;
      }

      // Validate payment method
      if (state.selectedPaymentMethod == null) {
        emit(state.copyWith(error: 'Please select a payment method'));
        return;
      }

      // Validate terms acceptance
      if (!state.termsAccepted) {
        emit(state.copyWith(error: 'Please accept the terms and conditions'));
        return;
      }

      // Validate cart items
      if (!_validateCartItems(event.cartItems)) {
        emit(state.copyWith(error: 'Invalid cart items. Please check your cart.'));
        return;
      }

      // Create the cart model for checkout
      final cartModel = CartModel(
        items: event.cartItems,
        paymentMethod: mapPaymentMethodToEnum(state.selectedPaymentMethod),
        voucherId: state.selectedVoucher?.voucherId,
        shippingInfoId: event.shippingInfoId,
      );

      // Dispatch checkout event
      add(Checkout(cartModelToCheckout: cartModel));
    } catch (e) {
      debugPrint('Error in ValidateAndPlaceOrder: $e');
      emit(state.copyWith(error: 'An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _onCheckout(
      Checkout event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final authBox = Hive.box('authentication');
      final loginToken = authBox.get('loginToken');
      debugPrint('- LoginToken exists: ${loginToken != null}');

      final cartToCheckout = event.cartModelToCheckout;

      debugPrint('Creating order with cart model: $cartToCheckout');

      try {
        final orderResponse = await orderRepository.createOrder(cartToCheckout);
        debugPrint('Order created successfully: $orderResponse');

        // Extract payment redirect URL if available
        final redirectUrl = orderResponse.paymentRedirectUrl;

        emit(state.copyWith(
          cartModelToCheckout: cartToCheckout,
          isLoading: false,
          isOrderCreated: true,
          redirectUrl: redirectUrl,
        ));
      } catch (orderError) {
        debugPrint('Error creating order: $orderError');
        throw Exception('Failed to create order: $orderError');
      }
    } catch (error) {
      debugPrint('Error during checkout: $error');
      String errorMessage = _formatErrorMessage(error.toString());

      emit(state.copyWith(
        error: errorMessage,
        isLoading: false,
        isOrderCreated: false,
      ));
    }
  }

  Future<void> _onApplyVoucher(
      ApplyVoucher event,
      Emitter<CheckoutState> emit
      ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final voucher = await voucherRepository?.getVoucherById(event.voucherId);

      if (voucher != null) {
        // Update the selected voucher
        emit(state.copyWith(
          selectedVoucher: voucher,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          error: 'Invalid voucher code',
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Error applying voucher: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  // Helper Methods

  bool _validateCartItems(List<CartItemModel> items) {
    if (items.isEmpty) {
      return false;
    }

    if (items.any((item) => item.skuId == null)) {
      return false;
    }

    return true;
  }

  PaymentMethod? _stringToPaymentMethod(String paymentMethod) {
    switch (paymentMethod.toUpperCase()) {
      case 'PAYPAL':
        return PaymentMethod.PAYPAL;
      case 'VNPAY':
        return PaymentMethod.VNPAY;
      default:
        return null;
    }
  }

  String _formatErrorMessage(String error) {
    // Convert technical errors to user-friendly messages
    if (error.contains('Shipping information is required') ||
        error.contains('shippingInfoId')) {
      return 'Please add a shipping address';
    } else if (error.contains('Payment method is required')) {
      return 'Please select a payment method';
    } else if (error.contains('No items in cart')) {
      return 'Your cart is empty. Please add items to your cart';
    } else if (error.contains('ShippingInfo does not belong to account')) {
      return 'The shipping address does not belong to your account. Please add a new shipping address.';
    } else if (error.contains('401') || error.contains('Unauthorized')) {
      return 'Your session has expired. Please log in again';
    }

    // Return original error if no matching patterns
    return error;
  }

  CartPaymentMethodEnum? mapPaymentMethodToEnum(PaymentMethod? method) {
    if (method == null) return null;

    switch (method) {
      case PaymentMethod.PAYPAL:
        return CartPaymentMethodEnum.PAYPAL;
      case PaymentMethod.VNPAY:
        return CartPaymentMethodEnum.VNPAY;
    }
  }
}