import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';

import '../../data/models/order_model.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class Checkout extends CheckoutEvent {
  final OrderModel? orders;
  final ShippingInfoModel? shippingInfo;
  final String? paymentMethod;


  const Checkout({this.orders, this.shippingInfo, this.paymentMethod});

  @override
  List<Object?> get props => [orders, shippingInfo, paymentMethod];
}

class SelectPaymentMethod extends CheckoutEvent {
  final String paymentMethod;

  const SelectPaymentMethod(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class OrderDetailAdded extends CheckoutEvent {
  final OrderDetailModel orderDetail;

  const OrderDetailAdded(this.orderDetail);

  @override
  List<Object?> get props => [orderDetail];
}

class OrderFetched extends CheckoutEvent {
  final int orderId;

  const OrderFetched(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class CalculateTotalPrice extends CheckoutEvent {}

class ApplyVoucher extends CheckoutEvent {
  final String voucherCode;

  ApplyVoucher(this.voucherCode);
}