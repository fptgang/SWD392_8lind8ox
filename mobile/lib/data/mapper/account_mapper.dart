import 'package:mobile/data/mapper/shipping_info_mapper.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:openapi/api.dart';

import '../models/shipping_info_model.dart';

/// Maps between AccountDto (API data) and AccountModel (app domain model)
class AccountMapper {
  /// Converts an API DTO to the internal model
  static AccountModel toModel(AccountDto dto) {
    return AccountModel(
      accountId: dto.accountId,
      firstName: dto.firstName,
      lastName: dto.lastName,
      email: dto.email,
      password: dto.password,
      avatarUrl: dto.avatarUrl,
      balance: dto.balance ?? 0,
      isVerified: dto.isVerified ?? false,
      verifiedAt: dto.verifiedAt,
      isVisible: dto.isVisible ?? true,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      defaultShippingInfo: ShippingInfoMapper.toModel(dto.defaultShippingInfo ?? ShippingInfoDto()),
    );
  }

  /// Converts an internal model to the API DTO
  static AccountDto toDto(AccountModel model) {
    return AccountDto(
      accountId: model.accountId,
      firstName: model.firstName,
      lastName: model.lastName,
      email: model.email,
      password: model.password,
      avatarUrl: model.avatarUrl,
      balance: model.balance,
      isVerified: model.isVerified,
      verifiedAt: model.verifiedAt,
      isVisible: model.isVisible,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      defaultShippingInfo: ShippingInfoMapper.toDto(model.defaultShippingInfo ?? ShippingInfoModel()),
    );
  }
}
