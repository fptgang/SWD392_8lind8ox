import 'package:mobile/enum/enum.dart';

class OrderStatusHistoryModel {
  final int orderStatusHistoryId;
  final int orderId;
  final int accountId;
  final OrderStatusHistoryEnum orderStatusHistoryEnum;
  final DateTime createdAt;

  OrderStatusHistoryModel({
    required this.orderStatusHistoryId,
    required this.orderId,
    required this.accountId,
    required this.orderStatusHistoryEnum,
    required this.createdAt,
  });

  List<Object> get props => [
    orderStatusHistoryId,
    orderId,
    accountId,
    orderStatusHistoryEnum,
    createdAt,
  ];
}