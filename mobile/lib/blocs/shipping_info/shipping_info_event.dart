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
  final ShippingInfoDto shippingInfoDto;

  CreateShippingInfo(this.shippingInfoDto);
}

// class SelectShippingInfo extends ShippingInfoEvent {
//   final int id;
//
//   SelectShippingInfo(this.id);
// }