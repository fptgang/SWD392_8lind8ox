import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/order_model.dart';

abstract class OrderEvent {
  const OrderEvent();

  List<Object?> get props => [];
}

class GetOrders extends OrderEvent {}

class GetOrderById extends OrderEvent {
  final int id;

  GetOrderById(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateOrder extends OrderEvent {
  final OrderModel order;

  UpdateOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class AddOrderDetail extends OrderEvent {
  final OrderDetailModel orderDetail;

  AddOrderDetail(this.orderDetail);

  List<Object?> get props => [orderDetail];
}

class LoadNextPage extends OrderEvent {}

class RefreshOrders extends OrderEvent {}

class UpdateFilter extends OrderEvent {
  final String filter;

  UpdateFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class UpdateSearch extends OrderEvent {
  final String search;

  UpdateSearch(this.search);

  @override
  List<Object?> get props => [search];
}
