import 'package:equatable/equatable.dart';
import 'package:mobile/cubit/cart_cubit/cart_cubit.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';

import '../../data/models/order_model.dart';
import '../../data/models/cart_model.dart';
import '../../data/models/promotional_campaign_model.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class Checkout extends CheckoutEvent {
  final CartModel? cartModelToCheckout;

  const Checkout({
    this.cartModelToCheckout,
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
  final PromotionModel? voucher;

  const UpdateSelectedVoucher(this.voucher);
  
  @override
  List<Object?> get props => [voucher];
}