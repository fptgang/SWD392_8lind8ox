import 'package:mobile/data/mapper/account_mapper.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:mobile/enum/enum.dart';
import 'package:openapi/api.dart';

class VoucherMapper{
  static VoucherModel toModel(VoucherDto dto){
    return VoucherModel(
      voucherId: dto.voucherId ?? 1,
      orderId: dto.orderId ?? 1,
      account: AccountMapper.toModel(dto.account ?? AccountDto()),
      code: dto.code!,
      discountRate: dto.discountRate ?? 0,
      limitAmount: dto.limitAmount ?? 100000000,
      status: toVoucherStateEnumModel(dto.state ?? VoucherDtoStateEnum.AVAILABLE),
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt ?? DateTime.now(),
      expiredAt: dto.expiredAt,
    );
  }

  static VoucherDto toDto(VoucherModel model) {
    return VoucherDto(
      voucherId: model.voucherId,
      orderId: model.orderId,
      state: toVoucherStateEnumDto(model.status ?? VoucherStatusEnum.AVAILABLE),
      account: AccountMapper.toDto(model.account ?? AccountModel()),
      code: model.code,
      discountRate: model.discountRate,
      limitAmount: model.limitAmount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      expiredAt: model.expiredAt,
    );
  }

  static VoucherStatusEnum toVoucherStateEnumModel(VoucherDtoStateEnum dto) {
    switch (dto) {
      case VoucherDtoStateEnum.AVAILABLE:
        return VoucherStatusEnum.AVAILABLE;
      case VoucherDtoStateEnum.USED:
        return VoucherStatusEnum.USED;
      case VoucherDtoStateEnum.RESERVED:
        return VoucherStatusEnum.RESERVED;
      default:
        throw Exception('Unknown order status: $dto');
    }
  }

  static VoucherDtoStateEnum toVoucherStateEnumDto(VoucherStatusEnum dto) {
    switch (dto) {
      case VoucherStatusEnum.AVAILABLE:
        return VoucherDtoStateEnum.AVAILABLE;
      case VoucherStatusEnum.USED:
        return VoucherDtoStateEnum.USED;
      case VoucherStatusEnum.RESERVED:
        return VoucherDtoStateEnum.RESERVED;
      default:
        throw Exception('Unknown order status: $dto');
    }
  }
}