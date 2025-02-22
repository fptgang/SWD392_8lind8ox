

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

class ShippingInfoRepositoryImpl implements ShippingInfoRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  ShippingInfoRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<ShippingInfoModel> createShippingInfo(ShippingInfoDto shippingInfo) {
    // TODO: implement createShippingInfo
    throw UnimplementedError();
  }

  @override
  Future<ShippingInfoModel> getShippingInfoById(int id) {
    // TODO: implement getShippingInfoById
    throw UnimplementedError();
  }

  @override
  Future<PaginationResponseGeneric<GetShippingInfos200Response>> getShippingInfos(Pageable pageable, String filter, String search) {
    // TODO: implement getShippingInfos
    throw UnimplementedError();
  }

}