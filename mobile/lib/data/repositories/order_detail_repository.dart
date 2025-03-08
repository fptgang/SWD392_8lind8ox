

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:openapi/api.dart';



@injectable
@Singleton()
abstract class OrderDetailRepository {
  Future<OrderDetailModel> getOrderDetailById(int orderId);
  Future<PaginationResponseGeneric<OrderDetailModel>> getOrderDetails(Pageable pageable, String filter, String search);
  Future<OrderDetailModel> createOrderDetail(OrderDetailModel orderDetailModel);
}