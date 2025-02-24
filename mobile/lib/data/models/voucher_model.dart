

class VoucherModel{
  final int voucherId;
  final int? orderId;
  final int? accountId;
  final String? code;
  final double discountRate;
  final double? limitAmount;
  final bool isUsed;
  final DateTime? createdAt;
  final DateTime? expiredAt;

  VoucherModel({
    required this.voucherId,
    this.orderId,
    this.accountId,
    this.code,
    required this.discountRate,
    this.limitAmount,
    this.isUsed = false,
    this.createdAt,
    this.expiredAt,
  });
}