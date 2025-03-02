import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:openapi/api.dart';

class ShippingInfoMapper {
  static ShippingInfoModel toModel(ShippingInfoDto dto) {
    return ShippingInfoModel(
      shippingInfoId: dto.shippingInfoId!,
      address: dto.address!,
      ward: dto.ward!,
      district: dto.district!,
      city: dto.city!,
      name: dto.name!,
      phoneNumber: dto.phoneNumber!,
      isVisible: dto.isVisible,
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
    );
  }

  static ShippingInfoDto toDto(ShippingInfoModel model) {
    return ShippingInfoDto(
      shippingInfoId: model.shippingInfoId,
      address: model.address,
      ward: model.ward,
      district: model.district,
      city: model.city,
      name: model.name,
      phoneNumber: model.phoneNumber,
      isVisible: model.isVisible,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
