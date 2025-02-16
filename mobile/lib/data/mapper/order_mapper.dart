

import 'package:openapi/api.dart';

import '../models/order_model.dart';

class OrderMapper {
  static OrderModel toModel(OrderDto dto) {
    return OrderModel(
      orderId: dto.orderId,
      accountId: dto.accountId,
      // orderStatus: dto.status,
      // orderStatusHistories: dto.orderStatusHistories.map((e) => OrderStatusHistoryMapper.toModel(e)).toList(),
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }
}