

import 'package:mobile/data/models/voucher_model.dart';
import 'package:openapi/api.dart';

class VoucherMapper{
  static VoucherModel toModel(VoucherDto dto){
    return VoucherModel(
      voucherId: dto.voucherId!,
      orderId: dto.orderId!,
      accountId: dto.accountId!,
      code: dto.code!,
      discountRate: dto.discountRate!,
      limitAmount: dto.limitAmount!,
      isUsed: dto.isUsed,
      createdAt: dto.createdAt!,
      expiredAt: dto.expiredAt,
    );
  }

  static VoucherDto toDto(VoucherModel model) {
    return VoucherDto(
      voucherId: model.voucherId,
      orderId: model.orderId,
      accountId: model.accountId,
      code: model.code,
      discountRate: model.discountRate,
      limitAmount: model.limitAmount,
      isUsed: model.isUsed,
      createdAt: model.createdAt,
      expiredAt: model.expiredAt,
    );
  }
}