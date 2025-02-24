import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/order_detail_model.dart';

abstract class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();

  @override
  List<Object?> get props => [];
}

class OrderDetailFetched extends OrderDetailEvent {
  final int orderId;

  const OrderDetailFetched(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class OrderDetailUpdated extends OrderDetailEvent {
  final OrderDetailModel orderDetail;

  const OrderDetailUpdated(this.orderDetail);

  @override
  List<Object?> get props => [orderDetail];
}

class CreateOrderDetail extends OrderDetailEvent {
  final OrderDetailModel orderDetail;

  const CreateOrderDetail(this.orderDetail);

  @override
  List<Object?> get props => [orderDetail];
}