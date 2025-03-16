import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/cart_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/data/models/voucher_model.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCheckout extends CheckoutEvent {
  final List<CartItemModel> selectedItems;

  const InitializeCheckout({required this.selectedItems});

  @override
  List<Object?> get props => [selectedItems];
}

class ValidateAndPlaceOrder extends CheckoutEvent {
  final List<CartItemModel> cartItems;
  final int? shippingInfoId;

  const ValidateAndPlaceOrder({
    required this.cartItems,
    required this.shippingInfoId,
  });

  @override
  List<Object?> get props => [cartItems, shippingInfoId];
}

class Checkout extends CheckoutEvent {
  final CartModel cartModelToCheckout;

  const Checkout({
    required this.cartModelToCheckout,
  });

  @override
  List<Object?> get props => [cartModelToCheckout];
}

class SelectPaymentMethod extends CheckoutEvent {
  final String paymentMethod;

  const SelectPaymentMethod(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class OrderFetched extends CheckoutEvent {
  final int orderId;

  const OrderFetched(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class CalculateTotalPrice extends CheckoutEvent {}

class ApplyVoucher extends CheckoutEvent {
  final int voucherId;

  const ApplyVoucher(this.voucherId);

  @override
  List<Object?> get props => [voucherId];
}

class SetTermsAccepted extends CheckoutEvent {
  final bool accepted;

  const SetTermsAccepted(this.accepted);

  @override
  List<Object?> get props => [accepted];
}

class UpdateSelectedVoucher extends CheckoutEvent {
  final VoucherModel? voucher;

  const UpdateSelectedVoucher(this.voucher);

  @override
  List<Object?> get props => [voucher];
}

class ClearCheckoutError extends CheckoutEvent {}