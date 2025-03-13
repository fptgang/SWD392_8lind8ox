import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/order/order_event.dart';
import 'package:mobile/blocs/order/order_state.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:openapi/api.dart';

@injectable
@lazySingleton
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;
  final PagingController<int, OrderModel> pagingController;

  OrderPaginationState _paginationState;
  OrderDataState _dataState;

  OrderBloc(this._orderRepository)
      : _paginationState = OrderPaginationState(pageable: Pageable(page: 1, size: 20)),
        _dataState = const OrderDataState(),
        pagingController = PagingController(firstPageKey: 1),
        super(OrderLoadingState()) {
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
    emit(OrderLoadingState(isLoading: true));

    try {
      final orders = await _orderRepository.getOrders(
        _paginationState.pageable,
        _dataState.filter ?? '',
        _dataState.search ?? '',
      );

      final isLastPage = orders.content.length < _paginationState.pageable.size;

      if (isLastPage) {
        pagingController.appendLastPage(orders.content);
      } else {
        pagingController.appendPage(
            orders.content,
            _paginationState.pageable.page + 1
        );
      }

      _paginationState = _paginationState.copyWith(
        hasReachedEnd: isLastPage,
      );

      _dataState = _dataState.copyWith(orders: orders);
      emit(_dataState);
    } catch (error) {
      pagingController.error = error;
      emit(OrderLoadingState(error: error.toString(), isLoading: false));
    }
  }

  Future<void> _onGetOrderById(
      GetOrderById event,
      Emitter<OrderState> emit,
      ) async {
    emit(OrderLoadingState(isLoading: true));

    try {
      final order = await _orderRepository.getOrderById(event.id);
      _dataState = _dataState.copyWith(order: order);
      emit(_dataState);
    } catch (error) {
      emit(OrderLoadingState(error: error.toString()));
    }
  }

  void _onUpdateOrder(
      UpdateOrder event,
      Emitter<OrderState> emit,
      ) {
    _dataState = _dataState.copyWith(order: event.order);
    emit(_dataState);

    // Refresh the orders list to reflect the update
    add(GetOrders());
  }

  void _onAddOrderDetail(
      AddOrderDetail event,
      Emitter<OrderState> emit,
      ) {
    if (_dataState.order == null) return;

    final currentDetails = _dataState.order!.orderDetails != null
        ? List<OrderDetailModel>.from(_dataState.order!.orderDetails!)
        : <OrderDetailModel>[];

    final index = currentDetails.indexWhere(
            (detail) => detail.orderDetailId == event.orderDetail.orderDetailId
    );

    if (index != -1) {
      currentDetails[index] = event.orderDetail;
    } else {
      currentDetails.add(event.orderDetail);
    }

    final updatedOrder = OrderModel(
      orderId: _dataState.order!.orderId,
      orderDetails: currentDetails,
      orderStatusHistories: _dataState.order!.orderStatusHistories,
      createdAt: _dataState.order!.createdAt,
      updatedAt: DateTime.now(),
      subTotal: _dataState.order!.subTotal,
      finalTotal: _dataState.order!.finalTotal,
    );

    _dataState = _dataState.copyWith(order: updatedOrder);
    emit(_dataState);
  }

  void _onLoadNextPage(
      LoadNextPage event,
      Emitter<OrderState> emit,
      ) {
    if (_paginationState.hasReachedEnd) return;

    final nextPage = _paginationState.pageable.page + 1;
    final newPageable = Pageable(
      page: nextPage,
      size: _paginationState.pageable.size,
      sort: _paginationState.pageable.sort,
    );

    _paginationState = _paginationState.copyWith(pageable: newPageable);
    add(GetOrders());
  }

  void _onRefreshOrders(
      RefreshOrders event,
      Emitter<OrderState> emit,
      ) {
    pagingController.refresh();

    final resetPageable = Pageable(
      page: 1,
      size: _paginationState.pageable.size,
      sort: _paginationState.pageable.sort,
    );

    _paginationState = _paginationState.copyWith(
        pageable: resetPageable,
        hasReachedEnd: false
    );

    add(GetOrders());
  }

  void _onUpdateFilter(
      UpdateFilter event,
      Emitter<OrderState> emit,
      ) {
    pagingController.refresh();

    _dataState = _dataState.copyWith(filter: event.filter);

    _paginationState = _paginationState.copyWith(
        pageable: Pageable(
            page: 1,
            size: _paginationState.pageable.size,
            sort: _paginationState.pageable.sort
        ),
        hasReachedEnd: false
    );

    emit(_dataState);
    add(GetOrders());
  }

  void _onUpdateSearch(
      UpdateSearch event,
      Emitter<OrderState> emit,
      ) {
    pagingController.refresh();

    _dataState = _dataState.copyWith(search: event.search);

    _paginationState = _paginationState.copyWith(
        pageable: Pageable(
            page: 1,
            size: _paginationState.pageable.size,
            sort: _paginationState.pageable.sort
        ),
        hasReachedEnd: false
    );

    emit(_dataState);
    add(GetOrders());
  }
}