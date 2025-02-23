import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/models/order_response_model.dart';
import 'package:openapi/api.dart';

class OrderState {
  Pageable pageable;
  final String? filter;
  final String? search;
  final bool? isLoading;
  final bool? isOutOfStock;
  final OrderResponseModel? orders;
  final OrderModel? order;
  final String? error;

  OrderState({
    Pageable? pageable,
    this.filter,
    this.search,
    this.isLoading,
    this.isOutOfStock,
    this.orders,
    this.order,
    this.error,
  }) : pageable = pageable ?? Pageable(page: 0, size: 10, sort: ['desc']);

  OrderState copyWith({
    Pageable? pageable,
    String? filter,
    String? search,
    bool? isLoading,
    bool? isOutOfStock,
    OrderResponseModel? orders,
    OrderModel? order,
    String? error,
  }) {
    return OrderState(
      pageable: pageable ?? this.pageable,
      filter: filter ?? this.filter,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      isOutOfStock: isOutOfStock ?? this.isOutOfStock,
      orders: orders ?? this.orders,
      order: order ?? this.order,
      error: error ?? this.error,
    );
  }
}
