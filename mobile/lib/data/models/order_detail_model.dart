import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/data/models/slot_model.dart';

class OrderDetailModel {
  final int orderDetailId;
  final int orderId;
  final StockKeepingUnitModel? sku;
  final int? quantity;
  final PromotionModel? promotionalCampaign;
  final double? unitPrice;
  final double? subTotal;
  final double? finalTotal;
  final SlotModel? slot;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderDetailModel({
    required this.orderDetailId,
    required this.orderId,
    this.sku,
    this.quantity,
    this.promotionalCampaign,
    this.unitPrice,
    this.subTotal,
    this.finalTotal,
    this.slot,
    this.createdAt,
    this.updatedAt,
  });

  List<Object?> get props => [
    orderDetailId,
    orderId,
    sku,
    quantity,
    promotionalCampaign,
    unitPrice,
    subTotal,
    finalTotal,
    slot,
    createdAt,
    updatedAt,
  ];
}