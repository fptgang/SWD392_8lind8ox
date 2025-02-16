import 'package:mobile/enum/enum.dart';

class OrderStatusHistoryModel {
  final int? orderStatusHistoryId;
  final int? orderId;
  final int? accountId;
  final OrderStatusHistoryEnum? orderStatus;
  final DateTime? createdAt;

  OrderStatusHistoryModel({
    this.orderStatusHistoryId,
    this.orderId,
    this.accountId,
    this.orderStatus,
    this.createdAt,
  });

  List<Object?> get props => [
    orderStatusHistoryId,
    orderId,
    accountId,
    orderStatus,
    createdAt,
  ];
}