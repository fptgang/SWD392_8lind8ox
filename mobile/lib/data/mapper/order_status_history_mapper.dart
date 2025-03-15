import 'package:mobile/data/mapper/order_mapper.dart';
import 'package:mobile/data/models/order_status_history_model.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:openapi/api.dart';

class OrderStatusHistoryMapper {
  static OrderStatusHistoryModel toOrderStatusHistoryModel(
      OrderStatusHistoryDto dto) {
    return OrderStatusHistoryModel(
      id: dto.id!,
      orderId: dto.orderId!,
      orderStatusHistoryEnum: OrderMapper.toLatestOrderStatusModel(dto.state!),
      createdAt: dto.createdAt!,
    );
  }

  static OrderStatusHistoryDto toDto(OrderStatusHistoryModel model) {
    return OrderStatusHistoryDto(
      id: model.id,
      orderId: model.orderId,
      state: OrderMapper.toLatestOrderStatusEnumDto(
          model.orderStatusHistoryEnum ?? OrderStatusEnum.CREATED),
      createdAt: model.createdAt,
    );
  }
}
