import 'package:mobile/data/models/create_shipping_info_model.dart';
import 'package:openapi/api.dart';

abstract class ShippingInfoEvent {}

class GetShippingInfos extends ShippingInfoEvent {
  final int pageKey;

  GetShippingInfos(this.pageKey);
}

class GetShippingInfoById extends ShippingInfoEvent {
  final int id;

  GetShippingInfoById(this.id);
}

class CreateShippingInfo extends ShippingInfoEvent {
  final CreateShippingInfoModel createShippingInfoModel;

  CreateShippingInfo(this.createShippingInfoModel);
}

// class SelectShippingInfo extends ShippingInfoEvent {
//   final int id;
//
//   SelectShippingInfo(this.id);
// }