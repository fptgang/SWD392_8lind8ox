import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/checkout/checkout_event.dart';
import 'package:mobile/blocs/checkout/checkout_state.dart';
import 'package:mobile/blocs/order_detail/order_detail_bloc.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:mobile/data/repositories/voucher_repository.dart';

import '../order_detail/order_detail_event.dart';

@injectable
@lazySingleton
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRepository orderRepository;
  final OrderDetailBloc orderDetailBloc;
  final VoucherRepository? _voucherRepository;

  CheckoutBloc(this._voucherRepository, {
    required this.orderRepository,
    required this.orderDetailBloc,
    VoucherRepository? voucherRepository,

  }) : super(const CheckoutState()) {

    on<Checkout>(_onCheckout);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<OrderDetailAdded>(_onOrderDetailAdded);
    on<OrderFetched>(_onOrderFetched);
    on<CalculateTotalPrice>(_onCalculateTotalPrice);
    // on<ApplyVoucher>(_onApplyVoucher);

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

      if (order.orderDetails != null) {
        for (var detail in order.orderDetails!) {
          orderDetailBloc.add(OrderDetailFetched(detail.orderDetailId));
        }
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

    final currentDetails = List<OrderDetailModel>.from(state.orders!.orderDetails ?? []);

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
      account: state.orders!.account,
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


    final updatedOrder = OrderModel(
      orderId: state.orders!.orderId,
      account: state.orders!.account,
      orderDetails: details,
      createdAt: state.orders!.createdAt,
      originalPrice: state.orders?.originalPrice,
      checkoutPrice: state.orders?.checkoutPrice,
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

      // if (event.orders == null || event.orders!.orderDetails.isEmpty) {
      //   throw Exception('No items in order');
      // }

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
        state.orders!.orderDetails?.isNotEmpty == true &&
        state.shippingInfo != null &&
        state.selectedPaymentMethod != null &&
        state.selectedPaymentMethod!.isNotEmpty;
  }
  // void _onApplyVoucher(ApplyVoucher event, Emitter<CheckoutState> emit) async {
  //   try {
  //     // Get the voucher by code from repository
  //     final voucher = await _voucherRepository.getVoucherByCode(event.voucherCode);
  //
  //     if (voucher != null) {
  //       emit(state.copyWith(selectedVoucher: voucher));
  //     } else {
  //       emit(state.copyWith(error: 'Invalid voucher code'));
  //     }
  //   } catch (e) {
  //     emit(state.copyWith(error: 'Error applying voucher: ${e.toString()}'));
  //   }
  // }

}