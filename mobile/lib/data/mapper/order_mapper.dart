

import 'package:mobile/data/mapper/order_detail_mapper.dart';
import 'package:mobile/data/mapper/order_status_history_mapper.dart';
import 'package:mobile/data/mapper/shipping_info_mapper.dart';
import 'package:mobile/data/mapper/voucher_mapper.dart';
import 'package:mobile/enum/enum.dart';
import 'package:openapi/api.dart';

import '../models/order_model.dart';

class OrderMapper {
  static OrderModel toModel(OrderDto dto) {
    return OrderModel(
      orderId: dto.orderId!,
      accountId: dto.accountId!,
      shippingInfo: dto.shippingInfo != null ? ShippingInfoMapper.toModel(dto.shippingInfo!): null,
      voucher: dto.voucher != null ? VoucherMapper.toModel(dto.voucher!) : null,
      orderDetails: dto.orderDetails.map((e) => OrderDetailMapper.toModel(e)).toList(),
      orderStatusHistories: dto.orderStatusHistories.map((e) => OrderStatusHistoryMapper.toOrderStatusHistoryModel(e)).toList(),
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
      originalPrice: dto.originalPrice!,
      checkoutPrice: dto.checkoutPrice!,
    );
  }

  static OrderStatusHistoryEnum toOrderStatusHistoryEnumModel(OrderStatusHistoryDtoStateEnum dto) {
    switch (dto) {
      case OrderStatusHistoryDtoStateEnum.CREATED:
        return OrderStatusHistoryEnum.CREATED;
      case OrderStatusHistoryDtoStateEnum.COURIER_ACCEPTED:
        return OrderStatusHistoryEnum.COURIER_ACCEPTED;
      case OrderStatusHistoryDtoStateEnum.SHIPPING:
        return OrderStatusHistoryEnum.SHIPPING;
      case OrderStatusHistoryDtoStateEnum.DELIVERED:
        return OrderStatusHistoryEnum.DELIVERED;
      case OrderStatusHistoryDtoStateEnum.RECEIVED:
        return OrderStatusHistoryEnum.RECEIVED;
      case OrderStatusHistoryDtoStateEnum.COMPLETED:
        return OrderStatusHistoryEnum.COMPLETED;
      default:
        throw Exception('Unknown order status: $dto');
    }
  }
}