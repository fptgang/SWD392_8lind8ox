import 'package:mobile/data/mapper/account_mapper.dart';
import 'package:mobile/data/mapper/order_detail_mapper.dart';
import 'package:mobile/data/mapper/order_status_history_mapper.dart';
import 'package:mobile/data/mapper/shipping_info_mapper.dart';
import 'package:mobile/data/mapper/transaction_mapper.dart';
import 'package:mobile/data/mapper/voucher_mapper.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/order_response_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:openapi/api.dart';

import '../models/order_model.dart';

class OrderMapper {
  static OrderModel toModel(OrderDto dto) {
    return OrderModel(
      orderId: dto.orderId!,
      account: AccountMapper.toModel(dto.account ?? AccountDto()),
      orderStatusHistories: dto.orderStatusHistories
          .map((e) => OrderStatusHistoryMapper.toOrderStatusHistoryModel(e))
          .toList(),
      latestStatus:
          toLatestOrderStatusModel(dto.latestStatus ?? OrderStatus.CREATED),
      orderDetails:
          dto.orderDetails.map((e) => OrderDetailMapper.toModel(e)).toList(),
      transaction:
          TransactionMapper.toModel(dto.transaction ?? TransactionDto()),
      shippingInfo: dto.shippingInfo != null
          ? ShippingInfoMapper.toModel(dto.shippingInfo!)
          : null,
      voucher: dto.voucher != null ? VoucherMapper.toModel(dto.voucher!) : null,
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
      subTotal: dto.subTotal,
      finalTotal: dto.finalTotal,
    );
  }

  static OrderStatusEnum toLatestOrderStatusModel(OrderStatus dto) {
    switch (dto) {
      case OrderStatus.CREATED:
        return OrderStatusEnum.CREATED;
      case OrderStatus.PREPARING:
        return OrderStatusEnum.PREPARING;
      case OrderStatus.PAYMENT_FAILED:
        return OrderStatusEnum.PAYMENT_FAILED;
      case OrderStatus.PAYMENT_EXPIRED:
        return OrderStatusEnum.PAYMENT_EXPIRED;
      case OrderStatus.CANCELED:
        return OrderStatusEnum.CANCELED;
      case OrderStatus.READY_FOR_PICKUP:
        return OrderStatusEnum.READY_FOR_PICKUP;
      case OrderStatus.SHIPPING:
        return OrderStatusEnum.SHIPPING;
      case OrderStatus.DELIVERED:
        return OrderStatusEnum.DELIVERED;
      case OrderStatus.RECEIVED:
        return OrderStatusEnum.RECEIVED;
      case OrderStatus.COMPLETED:
        return OrderStatusEnum.COMPLETED;
      default:
        throw Exception('Unknown order status: $dto');
    }
  }

  static OrderStatus toLatestOrderStatusEnumDto(OrderStatusEnum model) {
    switch (model) {
      case OrderStatusEnum.CREATED:
        return OrderStatus.CREATED;
      case OrderStatusEnum.PREPARING:
        return OrderStatus.PREPARING;
      case OrderStatusEnum.PAYMENT_FAILED:
        return OrderStatus.PAYMENT_FAILED;
      case OrderStatusEnum.PAYMENT_EXPIRED:
        return OrderStatus.PAYMENT_EXPIRED;
      case OrderStatusEnum.CANCELED:
        return OrderStatus.CANCELED;
      case OrderStatusEnum.READY_FOR_PICKUP:
        return OrderStatus.READY_FOR_PICKUP;
      case OrderStatusEnum.SHIPPING:
        return OrderStatus.SHIPPING;
      case OrderStatusEnum.DELIVERED:
        return OrderStatus.DELIVERED;
      case OrderStatusEnum.RECEIVED:
        return OrderStatus.RECEIVED;
      case OrderStatusEnum.COMPLETED:
        return OrderStatus.COMPLETED;
    }
  }

  static OrderDto toDto(OrderModel model) {
    return OrderDto(
        orderId: model.orderId,
        account: AccountMapper.toDto(model.account ?? AccountModel()),
        orderDetails:
            model.orderDetails!.map((e) => OrderDetailMapper.toDto(e)).toList(),
        orderStatusHistories: model.orderStatusHistories!
            .map((e) => OrderStatusHistoryMapper.toDto(e))
            .toList(),
        transaction:
            TransactionMapper.toDto(model.transaction ?? TransactionModel()),
        shippingInfo: model.shippingInfo != null
            ? ShippingInfoMapper.toDto(model.shippingInfo!)
            : null,
        voucher:
            model.voucher != null ? VoucherMapper.toDto(model.voucher!) : null,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        subTotal: model.subTotal,
        finalTotal: model.finalTotal);
  }

  static OrderResponseModel toOrderResponseModel(PlaceOrder200Response dto) {
    return OrderResponseModel(
      order: dto.order != null ? toModel(dto.order!) : null,
      paymentRedirectUrl: dto.paymentRedirectUrl,
    );
  }
}
