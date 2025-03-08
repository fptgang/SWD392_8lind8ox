abstract class ShippingInfoEvent {}

class GetShippingInfos extends ShippingInfoEvent {
  final int pageKey;

  GetShippingInfos(this.pageKey);
}

class GetShippingInfoById extends ShippingInfoEvent {
  final int id;

  GetShippingInfoById(this.id);
}

// class SelectShippingInfo extends ShippingInfoEvent {
//   final int id;
//
//   SelectShippingInfo(this.id);
// }