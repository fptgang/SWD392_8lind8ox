

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
}