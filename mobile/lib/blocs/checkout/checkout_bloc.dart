import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/checkout/checkout_event.dart';
import 'package:mobile/blocs/checkout/checkout_state.dart';
import 'package:mobile/data/mapper/order_mapper.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:openapi/api.dart';

import '../../data/models/order_model.dart';

@injectable
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final OrderRepository _orderRepository;
  final ShippingInfoRepository _shippingInfoRepository;

  CheckoutBloc(
      this._orderRepository,
      this._shippingInfoRepository,
      ) : super(const CheckoutState()) {
    on<Checkout>(_onCheckout);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
  }

  Future<void> _onCheckout(
      Checkout event,
      Emitter<CheckoutState> emit,
      ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final orderModel = OrderModel(
        orderId: event.orders!.orderId,
        accountId: event.orders!.accountId,
        shippingInfo: event.orders!.shippingInfo,
        voucher: event.orders!.voucher,
        orderDetails: event.orders!.orderDetails,
        orderStatusHistories: event.orders!.orderStatusHistories,
        createdAt: event.orders!.createdAt,
        updatedAt: event.orders!.updatedAt,
        originalPrice: event.orders!.originalPrice,
        checkoutPrice: event.orders!.checkoutPrice,
      );
      final order = await _orderRepository.createOrder(orderModel);

      emit(state.copyWith(
        orders: order,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onSelectPaymentMethod(
      SelectPaymentMethod event,
      Emitter<CheckoutState> emit,
      ) {
    emit(state.copyWith(selectedPaymentMethod: event.paymentMethod));
  }

  
}