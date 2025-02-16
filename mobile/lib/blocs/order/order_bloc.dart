

import 'package:bloc/bloc.dart';

import '../../data/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {


  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(OrderState());

}