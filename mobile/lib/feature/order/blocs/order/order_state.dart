import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:openapi/api.dart';

abstract class OrderState {}

class OrderPaginationState implements OrderState {
  final Pageable pageable;
  final bool hasReachedEnd;

  const OrderPaginationState({
    required this.pageable,
    this.hasReachedEnd = false,
  });

  OrderPaginationState copyWith({
    Pageable? pageable,
    bool? hasReachedEnd,
  }) {
    return OrderPaginationState(
      pageable: pageable ?? this.pageable,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class OrderLoadingState implements OrderState {
  final bool isLoading;
  final bool isOutOfStock;
  final String? error;

  const OrderLoadingState({
    this.isLoading = false,
    this.isOutOfStock = false,
    this.error,
  });

  OrderLoadingState copyWith({
    bool? isLoading,
    bool? isOutOfStock,
    String? error,
  }) {
    return OrderLoadingState(
      isLoading: isLoading ?? this.isLoading,
      isOutOfStock: isOutOfStock ?? this.isOutOfStock,
      error: error ?? this.error,
    );
  }
}

class OrderDataState implements OrderState {
  final PaginationResponseGeneric<OrderModel>? orders;
  final OrderModel? order;
  final String? filter;
  final String? search;

  const OrderDataState({
    this.orders,
    this.order,
    this.filter,
    this.search,
  });

  OrderDataState copyWith({
    PaginationResponseGeneric<OrderModel>? orders,
    OrderModel? order,
    String? filter,
    String? search,
  }) {
    return OrderDataState(
      orders: orders ?? this.orders,
      order: order ?? this.order,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}