import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/order_detail_model.dart';



class OrderDetailState extends Equatable {
  final OrderDetailModel? orderDetailModel;
  final bool? loading;
  final String? error;

  const OrderDetailState({ this.orderDetailModel, this.loading, this.error});

  OrderDetailState copyWith({OrderDetailModel? orderDetailModel, bool? isLoading, String? error}) {
    return OrderDetailState(
      orderDetailModel: orderDetailModel ?? this.orderDetailModel,
      loading: isLoading ?? loading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [orderDetailModel, loading, error];
}
