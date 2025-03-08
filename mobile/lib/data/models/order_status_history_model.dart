import 'package:mobile/enum/enum.dart';

class OrderStatusHistoryModel {
  final int? orderStatusHistoryId;
  final int? orderId;
  final OrderStatusHistoryEnum? orderStatusHistoryEnum;
  final DateTime? createdAt;

  OrderStatusHistoryModel({
    this.orderStatusHistoryId,
    this.orderId,
    this.orderStatusHistoryEnum,
    this.createdAt,
  });

  List<Object?> get props => [
    orderStatusHistoryId,
    orderId,
    orderStatusHistoryEnum,
    createdAt,
  ];
}