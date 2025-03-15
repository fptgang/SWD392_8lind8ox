import 'package:mobile/utils/enum/enum.dart';

class OrderStatusHistoryModel {
  final int? id;
  final int? orderId;
  final OrderStatusEnum? orderStatusHistoryEnum;
  final DateTime? createdAt;

  OrderStatusHistoryModel({
    this.id,
    this.orderId,
    this.orderStatusHistoryEnum,
    this.createdAt,
  });

  List<Object?> get props => [
        id,
        orderId,
        orderStatusHistoryEnum,
        createdAt,
      ];
}
