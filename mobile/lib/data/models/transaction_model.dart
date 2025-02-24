

import 'package:mobile/enum/enum.dart';

class TransactionModel{
  final int transactionId;
  final int accountId;
  final TransactionType type;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final double amount;
  final double oldBalance;
  final double newBalance;
  final int orderId;
  final bool success;

  TransactionModel({
    required this.transactionId,
    required this.accountId,
    required this.type,
    required this.paymentMethod,
    required this.createdAt,
    required this.amount,
    required this.oldBalance,
    required this.newBalance,
    required this.orderId,
    required this.success,
  });

  List<Object?> get props => [
    transactionId,
    accountId,
    type,
    paymentMethod,
    createdAt,
    amount,
    oldBalance,
    newBalance,
    orderId,
    success,
  ];
}