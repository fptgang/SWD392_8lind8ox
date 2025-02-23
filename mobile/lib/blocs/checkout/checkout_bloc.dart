import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/checkout/checkout_event.dart';
import 'package:mobile/blocs/checkout/checkout_state.dart';
import 'package:mobile/blocs/order_detail/order_detail_bloc.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';

import '../order_detail/order_detail_event.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRepository orderRepository;
  final OrderDetailBloc orderDetailBloc;

  CheckoutBloc({
    required this.orderRepository,
    required this.orderDetailBloc,
  }) : super(const CheckoutState()) {

    on<Checkout>(_onCheckout);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<OrderDetailAdded>(_onOrderDetailAdded);
    on<OrderFetched>(_onOrderFetched);
    on<CalculateTotalPrice>(_onCalculateTotalPrice);

    // Listen to OrderDetailBloc state changes
    orderDetailBloc.stream.listen((orderDetailState) {
      if (!orderDetailState.loading!) {
        add(OrderDetailAdded(orderDetailState.orderDetailModel!));
      }
    });
  }

  Future<void> _onOrderFetched(
      OrderFetched event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final order = await orderRepository.getOrderById(event.orderId);

      // For each order detail, fetch its data using OrderDetailBloc
      for (var detail in order.orderDetails) {
        orderDetailBloc.add(OrderDetailFetched(detail.orderDetailId));
      }

      emit(state.copyWith(
        orders: order,
        isLoading: false,
      ));

      add(CalculateTotalPrice());
    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
        isLoading: false,
      ));
    }
  }

  void _onOrderDetailAdded(
      OrderDetailAdded event,
      Emitter<CheckoutState> emit,
      ) {
    if (state.orders == null) return;

    final currentDetails = List<OrderDetailModel>.from(state.orders!.orderDetails);

    final index = currentDetails.indexWhere(
            (detail) => detail.orderDetailId == event.orderDetail.orderDetailId
    );

    if (index != -1) {
      currentDetails[index] = event.orderDetail;
    } else {
      currentDetails.add(event.orderDetail);
    }

    final updatedOrder = OrderModel(
      orderId: state.orders!.orderId,
      accountId: state.orders!.accountId,
      orderDetails: currentDetails,
      createdAt: state.orders!.createdAt,
      originalPrice: state.orders!.originalPrice,
      checkoutPrice: state.orders!.checkoutPrice,
      updatedAt: DateTime.now(),
    );

    emit(state.copyWith(orders: updatedOrder));
    add(CalculateTotalPrice());
  }

  void _onCalculateTotalPrice(
      CalculateTotalPrice event,
      Emitter<CheckoutState> emit,
      ) {
    if (state.orders == null) return;

    final details = state.orders!.orderDetails;

    final originalPrice = details.fold<double>(
      0,
          (sum, detail) => sum + detail.originalPrice,
    );

    final checkoutPrice = details.fold<double>(
            0,
          (sum, detail) => sum + (detail.checkoutPrice ?? detail.originalPrice),
    );

    final updatedOrder = OrderModel(
      orderId: state.orders!.orderId,
      accountId: state.orders!.accountId,
      orderDetails: details,
      createdAt: state.orders!.createdAt,
      originalPrice: originalPrice,
      checkoutPrice: checkoutPrice,
      updatedAt: DateTime.now(),
    );

    emit(state.copyWith(orders: updatedOrder));
  }

  void _onSelectPaymentMethod(
      SelectPaymentMethod event,
      Emitter<CheckoutState> emit,
      ) {
    emit(state.copyWith(selectedPaymentMethod: event.paymentMethod));
  }

  Future<void> _onCheckout(
      Checkout event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true));

      // Validate checkout data
      if (event.orders == null || event.orders!.orderDetails.isEmpty) {
        throw Exception('No items in order');
      }

      if (event.shippingInfo == null) {
        throw Exception('Shipping information is required');
      }

      if (event.paymentMethod == null || event.paymentMethod!.isEmpty) {
        throw Exception('Payment method is required');
      }

      emit(state.copyWith(
        orders: event.orders,
        shippingInfo: event.shippingInfo,
        selectedPaymentMethod: event.paymentMethod,
        isLoading: false,
      ));

    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
        isLoading: false,
      ));
    }
  }

  bool isCheckoutValid() {
    return state.orders != null &&
        state.orders!.orderDetails.isNotEmpty &&
        state.shippingInfo != null &&
        state.selectedPaymentMethod != null &&
        state.selectedPaymentMethod!.isNotEmpty;
  }
}