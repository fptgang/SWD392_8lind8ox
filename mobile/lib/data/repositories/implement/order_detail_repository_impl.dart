

import 'package:hive_flutter/adapters.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/order_detail_model.dart';
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
  Future<OrderDetailModel> getOrderDetailById(int orderId) async {
   // try{
   //    OrderDetailDto? orderDetailDto = await _apiService.getO(orderId);
   //    if(orderDetailDto == null){
   //      throw Exception('Cannot get order detail information');
   //    }
   //    OrderDetailModel orderDetailModel = OrderDetailModel.fromDto(orderDetailDto);
   //    return orderDetailModel;
   //  } catch(e){
   //    throw Exception('Cannot get order detail information');
   // }
    throw UnimplementedError();
  }

  @override
  Future<PaginationResponseGeneric<OrderDetailModel>> getOrderDetails(Pageable pageable, String filter, String search) {
    // TODO: implement getOrderDetails
    throw UnimplementedError();
  }

  @override
  Future<OrderDetailModel> createOrderDetail(OrderDetailModel orderDetailModel) {
    // TODO: implement createOrderDetail
    throw UnimplementedError();
  }
}