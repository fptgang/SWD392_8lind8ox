import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/order/order_event.dart';
import 'package:mobile/blocs/order/order_state.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:openapi/api.dart';


class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({
    required this.orderRepository,
  }) : super(OrderState()) {
    on<GetOrders>(_onGetOrders);
    on<GetOrderById>(_onGetOrderById);
    on<UpdateOrder>(_onUpdateOrder);
    on<AddOrderDetail>(_onAddOrderDetail);
    on<LoadNextPage>(_onLoadNextPage);
    on<RefreshOrders>(_onRefreshOrders);
    on<UpdateFilter>(_onUpdateFilter);
    on<UpdateSearch>(_onUpdateSearch);
  }

  Future<void> _onGetOrders(
      GetOrders event,
      Emitter<OrderState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final orders = await orderRepository.getOrders(
        state.pageable,
        state.filter ?? '',
        state.search ?? '',
      );

      emit(state.copyWith(
        orders: orders,
        isLoading: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onGetOrderById(
      GetOrderById event,
      Emitter<OrderState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true));

      final order = await orderRepository.getOrderById(event.id);

      emit(state.copyWith(
        order: order,
        isLoading: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
        isLoading: false,
      ));
    }
  }

  void _onUpdateOrder(
      UpdateOrder event,
      Emitter<OrderState> emit,
      ) {
    emit(state.copyWith(order: event.order));

    // Refresh the orders list to reflect the update
    add(GetOrders());
  }

  void _onAddOrderDetail(
      AddOrderDetail event,
      Emitter<OrderState> emit,
      ) {
    if (state.order == null) return;

    final currentDetails = List<OrderDetailModel>.from(state.order!.orderDetails);

    final index = currentDetails.indexWhere(
            (detail) => detail.orderDetailId == event.orderDetail.orderDetailId
    );

    if (index != -1) {
      currentDetails[index] = event.orderDetail;
    } else {
      currentDetails.add(event.orderDetail);
    }

    final updatedOrder = OrderModel(
      orderId: state.order!.orderId,
      accountId: state.order!.accountId,
      orderDetails: currentDetails,
      orderStatusHistories: state.order!.orderStatusHistories,
      createdAt: state.order!.createdAt,
      updatedAt: DateTime.now(),
      originalPrice: state.order!.originalPrice,
      checkoutPrice: state.order!.checkoutPrice,
    );

    emit(state.copyWith(order: updatedOrder));
  }

  void _onLoadNextPage(
      LoadNextPage event,
      Emitter<OrderState> emit,
      ) {
    if (state.isLoading == true) return;
    if (state.orders?.last == true) return;

    final nextPage = state.pageable.page + 1;
    final newPageable = Pageable(
      page: nextPage,
      size: state.pageable.size,
      sort: state.pageable.sort,
    );

    emit(state.copyWith(pageable: newPageable));
    add(GetOrders());
  }

  void _onRefreshOrders(
      RefreshOrders event,
      Emitter<OrderState> emit,
      ) {
    final resetPageable = Pageable(
      page: 0,
      size: state.pageable.size,
      sort: state.pageable.sort,
    );

    emit(state.copyWith(pageable: resetPageable));
    add(GetOrders());
  }

  void _onUpdateFilter(
      UpdateFilter event,
      Emitter<OrderState> emit,
      ) {
    emit(state.copyWith(
      filter: event.filter,
      pageable: Pageable(page: 0, size: state.pageable.size, sort: state.pageable.sort),
    ));
    add(GetOrders());
  }

  void _onUpdateSearch(
      UpdateSearch event,
      Emitter<OrderState> emit,
      ) {
    emit(state.copyWith(
      search: event.search,
      pageable: Pageable(page: 0, size: state.pageable.size, sort: state.pageable.sort),
    ));
    add(GetOrders());
  }
}