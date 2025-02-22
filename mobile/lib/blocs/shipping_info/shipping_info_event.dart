abstract class ShippingInfoEvent {}

class GetShippingInfos extends ShippingInfoEvent {}

class GetShippingInfoById extends ShippingInfoEvent {
  final int id;

  GetShippingInfoById(this.id);
}