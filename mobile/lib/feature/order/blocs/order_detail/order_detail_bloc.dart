import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/repositories/order_detail_repository.dart';
import 'package:mobile/feature/order/blocs/order_detail/order_detail_event.dart';
import 'package:mobile/feature/order/blocs/order_detail/order_detail_state.dart';

@injectable
@lazySingleton
class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final OrderDetailRepository orderDetailRepository;

  OrderDetailBloc({required this.orderDetailRepository})
      : super(OrderDetailState()) {
    on<OrderDetailFetched>(_onOrderDetailFetched);
    on<OrderDetailUpdated>(_onOrderDetailUpdated);
    on<CreateOrderDetail>(_onOrderDetailToCheckout);
  }

  Future<void> _onOrderDetailFetched(
    OrderDetailFetched event,
    Emitter<OrderDetailState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final orderDetail =
          await orderDetailRepository.getOrderDetailById(event.orderId);
      emit(state.copyWith(
        orderDetailModel: orderDetail,
        isLoading: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
        isLoading: false,
      ));
    }
  }

  void _onOrderDetailUpdated(
    OrderDetailUpdated event,
    Emitter<OrderDetailState> emit,
  ) {
    emit(state.copyWith(orderDetailModel: event.orderDetail));
  }

  Future<void> _onOrderDetailToCheckout(
    CreateOrderDetail event,
    Emitter<OrderDetailState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await orderDetailRepository.createOrderDetail(event.orderDetail);
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
        isLoading: false,
      ));
    }
  }
}
