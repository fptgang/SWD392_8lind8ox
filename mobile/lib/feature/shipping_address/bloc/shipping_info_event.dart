import 'package:mobile/data/models/create_shipping_info_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:openapi/api.dart';

abstract class ShippingInfoEvent {}

class GetShippingInfos extends ShippingInfoEvent {

  GetShippingInfos();
}

class GetShippingInfoById extends ShippingInfoEvent {
  final int id;

  GetShippingInfoById(this.id);
}

class CreateShippingInfo extends ShippingInfoEvent {
  final CreateShippingInfoModel createShippingInfoModel;

  CreateShippingInfo(this.createShippingInfoModel);
}

class UpdateShippingInfo extends ShippingInfoEvent {
  final int id;
  final CreateShippingInfoModel updateShippingInfoModel;

  UpdateShippingInfo(this.id, this.updateShippingInfoModel);
}

class DeleteShippingInfo extends ShippingInfoEvent {
  final int id;

  DeleteShippingInfo(this.id);
}

class SelectShippingInfo extends ShippingInfoEvent {
  final ShippingInfoModel shippingInfo;

  SelectShippingInfo(this.shippingInfo);
}

class SetDefaultShippingInfo extends ShippingInfoEvent {
  final int id;

  SetDefaultShippingInfo(this.id);
}

class UpdateFilter extends ShippingInfoEvent {
  final String filter;

  UpdateFilter(this.filter);
}

class UpdateSearch extends ShippingInfoEvent {
  final String search;

  UpdateSearch(this.search);
}

class RefreshShippingInfos extends ShippingInfoEvent {}