

import 'package:hive_flutter/adapters.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/order_detail_response_model.dart';
import 'package:openapi/api.dart';
import '../../../di/injection.dart';
import '../order_detail_repository.dart';

class OrderDetailRepositoryImpl implements OrderDetailRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  OrderDetailRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<OrderDetailModel> getOrderDetailById(int orderId) {
    // TODO: implement getOrderDetailById
    throw UnimplementedError();
  }

  @override
  Future<OrderDetailResponseModel> getOrderDetails(Pageable pageable, String filter, String search) {
    // TODO: implement getOrderDetails
    throw UnimplementedError();
  }

  @override
  Future<OrderDetailModel> createOrderDetail(OrderDetailDto orderDetailDto) {
    // TODO: implement createOrderDetail
    throw UnimplementedError();
  }
}