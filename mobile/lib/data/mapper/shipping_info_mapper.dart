import 'package:mobile/data/models/create_shipping_info_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:openapi/api.dart';

/// Maps between ShippingInfoDto (API data) and ShippingInfoModel (app domain model)
class ShippingInfoMapper {
  static ShippingInfoModel toModel(ShippingInfoDto dto) {
    return ShippingInfoModel(
      shippingInfoId: dto.shippingInfoId ?? 0,
      address: dto.address ?? '',
      ward: dto.ward ?? '',
      district: dto.district ?? '',
      city: dto.city ?? '',
      name: dto.name ?? '',
      phoneNumber: dto.phoneNumber ?? '',
      isVisible: dto.isVisible,
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt,
    );
  }

  /// Converts an internal model to the API DTO
  static ShippingInfoDto toDto(ShippingInfoModel model) {
    return ShippingInfoDto(
      shippingInfoId: model.shippingInfoId,
      address: model.address,
      ward: model.ward,
      district: model.district,
      city: model.city,
      name: model.name,
      phoneNumber: model.phoneNumber,
      isVisible: model.isVisible ?? true,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static ShippingInfoModel fromCreateToModel(CreateShippingInfoModel model) {
    return ShippingInfoModel(
      address: model.address,
      ward: model.ward,
      district: model.district,
      city: model.city,
      name: model.name,
      phoneNumber: model.phoneNumber,
      isVisible: model.isVisible ?? true,
    );
  }

  static ShippingInfoDto fromCreateToDto(CreateShippingInfoModel model) {
    return ShippingInfoDto(
      address: model.address,
      ward: model.ward,
      district: model.district,
      city: model.city,
      name: model.name,
      phoneNumber: model.phoneNumber,
      isVisible: model.isVisible ?? true,
    );
  }
}
