import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/order_model.dart';

class OrderState extends Equatable {
  final OrderModel? orders;
  final bool? loading;
  final String? error;

  OrderState({this.orders, this.loading, this.error});

  OrderState copyWith({OrderModel? orders, bool? isLoading, String? error}) {
    return OrderState(
      orders: orders ?? this.orders,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [orders, loading, error];
}
