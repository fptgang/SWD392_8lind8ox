import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:openapi/api.dart';

/// Maps between ShippingInfoDto (API data) and ShippingInfoModel (app domain model)
class ShippingInfoMapper {
  /// Converts an API DTO to the internal model
  static ShippingInfoModel toModel(ShippingInfoDto dto) {
    return ShippingInfoModel(
      shippingInfoId: dto.shippingInfoId ?? 0,
      address: dto.address ?? '',
      ward: dto.ward ?? '',
      district: dto.district ?? '',
      city: dto.city ?? '',
      name: dto.name ?? '',
      phoneNumber: dto.phoneNumber ?? '',
      isVisible: dto.isVisible ?? true,
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
      isVisible: model.isVisible,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
