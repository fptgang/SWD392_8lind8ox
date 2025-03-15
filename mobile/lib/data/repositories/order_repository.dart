import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/order_response_model.dart';
import 'package:mobile/feature/cart/cubits/cart_cubit.dart';
import 'package:openapi/api.dart';

import '../models/order_model.dart';

abstract class OrderRepository {
  Future<OrderModel> getOrderById(int orderId);
  Future<PaginationResponseGeneric<OrderModel>> getOrders(
      Pageable pageable, String filter, String search);
  Future<OrderResponseModel> createOrder(CartModel cartModel);
}
