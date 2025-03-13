

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/create_shipping_info_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:openapi/api.dart';

@injectable
@Singleton()
abstract class ShippingInfoRepository {
  Future<ShippingInfoModel> getShippingInfoById(int id);
  Future<ShippingInfoModel> createShippingInfo(CreateShippingInfoModel shippingInfo);
  Future<PaginationResponseGeneric<ShippingInfoModel>> getShippingInfos(Pageable pageable, String filter, String search);
}