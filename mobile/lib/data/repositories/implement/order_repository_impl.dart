

import 'package:hive_flutter/adapters.dart';
import 'package:mobile/data/models/order_model.dart';
import 'package:mobile/data/models/order_response_model.dart';
import 'package:mobile/data/repositories/order_repository.dart';
import 'package:openapi/api.dart';

import '../../../di/injection.dart';

class OrderRepositoryImpl implements OrderRepository{

  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();


  OrderRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });

}

  @override
  Future<OrderModel> getOrderById(int orderId) {
    // TODO: implement getOrderById
    throw UnimplementedError();
  }

  @override
  Future<OrderResponseModel> getOrders(Pageable pageable, String filter, String search) {
    // TODO: implement getOrders
    throw UnimplementedError();
  }

  @override
  Future<OrderModel> createOrder(OrderDto orderDto) {
    // TODO: implement createOrder
    throw UnimplementedError();
  }
}