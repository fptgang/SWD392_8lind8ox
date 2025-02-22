

import 'package:mobile/data/mapper/order_mapper.dart';
import 'package:mobile/data/models/order_status_history_model.dart';
import 'package:openapi/api.dart';

class OrderStatusHistoryMapper {
  static OrderStatusHistoryModel toOrderStatusHistoryModel(OrderStatusHistoryDto dto) {
    return OrderStatusHistoryModel(
      orderStatusHistoryId: dto.id!,
      orderId: dto.orderId!,
      accountId: dto.accountId!,
      orderStatusHistoryEnum: OrderMapper.toOrderStatusHistoryEnumModel(dto.state!),
      createdAt: dto.createdAt!,
    );
  }
}