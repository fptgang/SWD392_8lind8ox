import 'package:openapi/api.dart';
import '../models/order_model.dart';
import '../models/order_response_model.dart';

abstract class OrderRepository {

  Future<OrderModel> getOrderById(int orderId);
  Future<OrderResponseModel> getOrders(Pageable pageable, String filter, String search);
  Future<OrderModel> createOrder(OrderDto orderDto);
}