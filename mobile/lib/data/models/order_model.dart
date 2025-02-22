import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/models/voucher_model.dart';
import 'package:mobile/enum/enum.dart';
import 'order_detail_model.dart';
import 'order_status_history_model.dart';

class OrderModel {
  final int orderId;
  final int accountId;
  final ShippingInfoModel? shippingInfo;
  final VoucherModel? voucher;
  final List<OrderDetailModel> orderDetails;
  final List<OrderStatusHistoryModel>? orderStatusHistories;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double originalPrice;
  final double checkoutPrice;

  OrderModel({
    required this.orderId,
    required this.accountId,
    this.shippingInfo,
    this.voucher,
    required this.orderDetails,
    this.orderStatusHistories,
    required this.createdAt,
    this.updatedAt,
    required this.originalPrice,
    required this.checkoutPrice,
  });
}