

import 'package:mobile/data/mapper/order_mapper.dart';
import 'package:mobile/data/models/order_status_history_model.dart';
import 'package:mobile/enum/enum.dart';
import 'package:openapi/api.dart';

class OrderStatusHistoryMapper {
  static OrderStatusHistoryModel toOrderStatusHistoryModel(OrderStatusHistoryDto dto) {
    return OrderStatusHistoryModel(
      orderStatusHistoryId: dto.id!,
      orderId: dto.orderId!,
      orderStatusHistoryEnum: OrderMapper.toOrderStatusHistoryEnumModel(dto.state!),
      createdAt: dto.createdAt!,
    );
  }

  static OrderStatusHistoryDto toDto(OrderStatusHistoryModel model) {
    return OrderStatusHistoryDto(
      id: model.orderStatusHistoryId,
      orderId: model.orderId,
      state: OrderMapper.toOrderStatusHistoryEnumDto(model.orderStatusHistoryEnum ?? OrderStatusHistoryEnum.CREATED),
      createdAt: model.createdAt,
    );
  }
}