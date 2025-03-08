

import 'package:mobile/data/mapper/account_mapper.dart';
import 'package:mobile/data/mapper/order_detail_mapper.dart';
import 'package:mobile/data/mapper/order_status_history_mapper.dart';
import 'package:mobile/data/mapper/shipping_info_mapper.dart';
import 'package:mobile/data/mapper/transaction_mapper.dart';
import 'package:mobile/data/mapper/voucher_mapper.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/order_response_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/enum/enum.dart';
import 'package:openapi/api.dart';

import '../models/order_model.dart';

class OrderMapper {
  static OrderModel toModel(OrderDto dto) {
    return OrderModel(
      orderId: dto.orderId!,
      account: AccountMapper.toModel(dto.account ?? AccountDto()),
      orderStatusHistories: dto.orderStatusHistories.map((e) => OrderStatusHistoryMapper.toOrderStatusHistoryModel(e)).toList(),
      orderDetails: dto.orderDetails.map((e) => OrderDetailMapper.toModel(e)).toList(),
      transaction: TransactionMapper.toModel(dto.transaction ?? TransactionDto()),
      shippingInfo: dto.shippingInfo != null ? ShippingInfoMapper.toModel(dto.shippingInfo!): null,
      voucher: dto.voucher != null ? VoucherMapper.toModel(dto.voucher!) : null,
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
  static OrderDto toDto(OrderModel model) {
    return OrderDto(
      orderId: model.orderId,
      account: AccountMapper.toDto(model.account ?? AccountModel()),
      orderDetails: model.orderDetails!.map((e) => OrderDetailMapper.toDto(e)).toList(),
      orderStatusHistories: model.orderStatusHistories!.map((e) => OrderStatusHistoryMapper.toDto(e)).toList(),
      transaction: TransactionMapper.toDto(model.transaction ?? TransactionModel()),
      shippingInfo: model.shippingInfo != null
          ? ShippingInfoMapper.toDto(model.shippingInfo!)
          : null,
      voucher: model.voucher != null
          ? VoucherMapper.toDto(model.voucher!)
          : null,

      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      originalPrice: model.originalPrice,
      checkoutPrice: model.checkoutPrice,
    );
  }

  static OrderStatusHistoryDtoStateEnum toOrderStatusHistoryEnumDto(OrderStatusHistoryEnum model) {
    switch (model) {
      case OrderStatusHistoryEnum.CREATED:
        return OrderStatusHistoryDtoStateEnum.CREATED;
      case OrderStatusHistoryEnum.COURIER_ACCEPTED:
        return OrderStatusHistoryDtoStateEnum.COURIER_ACCEPTED;
      case OrderStatusHistoryEnum.SHIPPING:
        return OrderStatusHistoryDtoStateEnum.SHIPPING;
      case OrderStatusHistoryEnum.DELIVERED:
        return OrderStatusHistoryDtoStateEnum.DELIVERED;
      case OrderStatusHistoryEnum.RECEIVED:
        return OrderStatusHistoryDtoStateEnum.RECEIVED;
      case OrderStatusHistoryEnum.COMPLETED:
        return OrderStatusHistoryDtoStateEnum.COMPLETED;
      }
  }

  static OrderResponseModel toOrderResponseModel(PlaceOrder200Response dto) {
    return OrderResponseModel(
      order: dto.order != null ? toModel(dto.order!) : null,
      paymentRedirectUrl: dto.paymentRedirectUrl,
    );
  }
}