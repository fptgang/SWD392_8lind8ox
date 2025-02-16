import 'package:mobile/enum/enum.dart';
import 'order_detail_model.dart';
import 'order_status_history_model.dart';

class OrderModel {
  final int? orderId;
  final int? accountId;
  final OrderStatusHistoryEnum? orderStatus;
  final List<OrderDetailModel> orderDetails;
  final List<OrderStatusHistoryModel> orderStatusHistories;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? totalPrice;

  OrderModel({
    this.orderId,
    this.accountId,
    this.orderStatus,
    this.orderDetails = const [],
    this.orderStatusHistories = const [],
    this.createdAt,
    this.updatedAt,
    this.totalPrice,
  });

}