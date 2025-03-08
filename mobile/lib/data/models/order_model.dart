import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:mobile/enum/enum.dart';
import 'order_detail_model.dart';
import 'order_status_history_model.dart';

class OrderModel {
  final int? orderId;
  final AccountModel? account;
  final List<OrderStatusHistoryModel>? orderStatusHistories;
  final List<OrderDetailModel>? orderDetails;
  final TransactionModel? transaction;
  final ShippingInfoModel? shippingInfo;
  final VoucherModel? voucher;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? originalPrice;
  final double? checkoutPrice;

  OrderModel({
    this.orderId,
    this.account,
    this.orderStatusHistories,
    this.orderDetails,
    this.transaction,
    this.shippingInfo,
    this.voucher,
    this.createdAt,
    this.updatedAt,
    this.originalPrice,
    this.checkoutPrice,
  });
}