

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:openapi/api.dart';

import '../models/order_detail_response_model.dart';


@injectable
@Singleton()
abstract class OrderDetailRepository {
  Future<OrderDetailModel> getOrderDetailById(int orderId);
  Future<OrderDetailResponseModel> getOrderDetails(Pageable pageable, String filter, String search);
  Future<OrderDetailModel> createOrderDetail(OrderDetailDto orderDetailDto);
}