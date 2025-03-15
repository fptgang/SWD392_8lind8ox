import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/utils/enum/enum.dart';

class VoucherModel {
  final int? voucherId;
  final int? orderId;
  final AccountModel? account;
  final String? code;
  final double? discountRate;
  final double? limitAmount;
  final VoucherStatusEnum? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiredAt;

  VoucherModel({
    this.voucherId,
    this.orderId,
    this.account,
    this.code,
    this.discountRate,
    this.limitAmount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.expiredAt,
  });

  List<Object?> get props => [
        voucherId,
        orderId,
        account,
        code,
        discountRate,
        limitAmount,
        status,
        createdAt,
        updatedAt,
        expiredAt,
      ];
}
