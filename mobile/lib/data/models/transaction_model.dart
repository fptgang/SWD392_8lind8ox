import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/utils/enum/enum.dart';

class TransactionModel {
  final int? transactionId;
  final AccountModel? account;
  final TransactionType? type;
  final PaymentMethod? paymentMethod;
  final DateTime? createdAt;
  final double? amount;
  final double? oldBalance;
  final double? newBalance;
  final int? orderId;
  final TransactionStatusEnum? status;

  TransactionModel({
    this.transactionId,
    this.account,
    this.type,
    this.paymentMethod,
    this.createdAt,
    this.amount,
    this.oldBalance,
    this.newBalance,
    this.orderId,
    this.status,
  });

  List<Object?> get props => [
        transactionId,
        account,
        type,
        paymentMethod,
        createdAt,
        amount,
        oldBalance,
        newBalance,
        orderId,
        status,
      ];
}
