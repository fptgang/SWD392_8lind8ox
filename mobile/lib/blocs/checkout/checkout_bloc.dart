import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/checkout/checkout_event.dart';
import 'package:mobile/blocs/checkout/checkout_state.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:mobile/data/repositories/voucher_repository.dart';
import 'package:mobile/enum/enum.dart';

@injectable
@lazySingleton
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRepository orderRepository;
  final VoucherRepository? _voucherRepository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CheckoutBloc(
      this._voucherRepository, {
        required this.orderRepository,
      }) : super(const CheckoutState()) {
    on<Checkout>(_onCheckout);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<OrderFetched>(_onOrderFetched);
    on<CalculateTotalPrice>(_onCalculateTotalPrice);
    on<ApplyVoucher>(_onApplyVoucher);
    on<SetTermsAccepted>(_onSetTermsAccepted);
    on<UpdateSelectedVoucher>(_onUpdateSelectedVoucher);
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
      emit(state.copyWith(isLoading: true));

      // Fetch the order details from the repository - just for viewing
      final order = await orderRepository.getOrderById(event.orderId);

      // Since we're just viewing, we don't need to convert to CartModel
      // Implementation will depend on how you want to display order details
      // For now we'll leave the state as is with updated loading flag

      emit(state.copyWith(
        isLoading: false,
        // You might want to store the order in another state property
        // or pass it directly to the UI
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

  Future<void> _onCheckout(
      Checkout event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      // Use the provided cart model if available, otherwise use the current state
      final cartToCheckout = event.cartModelToCheckout ?? state.cartModelToCheckout;

      if (cartToCheckout == null) {
        throw Exception('No items in cart');
      }

      if (cartToCheckout.shippingInfoId == null) {
        throw Exception('Shipping information is required');
      }

      if (cartToCheckout.paymentMethod == null) {
        throw Exception('Payment method is required');
      }

      // Here you would call the repository to create an order
      // For example:
      // final orderResponse = await orderRepository.createOrder(cartToCheckout, userId);

      emit(state.copyWith(
        cartModelToCheckout: cartToCheckout,
        isLoading: false,
        isOrderCreated: true,
      ));

    } catch (error) {
      debugPrint('Error during checkout: $error');
      emit(state.copyWith(
        error: error.toString(),
        isLoading: false,
      ));
    }
  }

  void _onApplyVoucher(ApplyVoucher event, Emitter<CheckoutState> emit) async {
    try {
      if (state.cartModelToCheckout == null) return;

      // Get the voucher by code from repository
      final voucher = await _voucherRepository?.getVoucherById(event.voucherId);

      if (voucher != null) {
        // Update the cart with the voucher ID
        final updatedCart = state.cartModelToCheckout!.copyWith(
          voucherId: voucher.voucherId,
        );

        emit(state.copyWith(
          cartModelToCheckout: updatedCart,
        ));
      } else {
        emit(state.copyWith(error: 'Invalid voucher code'));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Error applying voucher: ${e.toString()}'));
    }
  }

  bool isCheckoutValid() {
    return state.cartModelToCheckout != null &&
        state.cartModelToCheckout!.items?.isNotEmpty == true &&
        state.cartModelToCheckout!.shippingInfoId != null &&
        state.cartModelToCheckout!.paymentMethod != null &&
        state.termsAccepted;
  }

  // Helper methods
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

  CartPaymentMethodEnum? mapPaymentMethodToEnum(PaymentMethod? method) {
    if (method == null) return null;
    
    switch (method) {
      case PaymentMethod.PAYPAL:
        return CartPaymentMethodEnum.PAYPAL;
      case PaymentMethod.VNPAY:
        return CartPaymentMethodEnum.VNPAY;
      default:
        return null;
    }
  }
}