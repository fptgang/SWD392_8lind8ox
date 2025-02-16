

import 'package:openapi/api.dart';

import '../models/order_status_history_model.dart';

class OrderStatusHistoryMapper {
  static OrderStatusHistoryModel toModel(OrderStatusHistoryDto dto) {
    return OrderStatusHistoryModel(
      orderStatusHistoryId: dto.id,
      orderId: dto.orderId,
      accountId: dto.accountId,
      // orderStatus: dto.state,
      createdAt: dto.createdAt,
    );
  }
}