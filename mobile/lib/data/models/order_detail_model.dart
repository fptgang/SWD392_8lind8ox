import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:mobile/data/models/slot_model.dart';

class OrderDetailModel {
  final int orderDetailId;
  final int orderId;
  final StockKeepingUnitModel? sku;
  final int? quantity;
  final PromotionModel? promotionalCampaign;
  final double? originalPrice;
  final double? checkoutPrice;
  final SlotModel? slot;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderDetailModel({
    required this.orderDetailId,
    required this.orderId,
    this.sku,
    this.quantity,
    this.promotionalCampaign,
    this.originalPrice,
    this.checkoutPrice,
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
    originalPrice,
    checkoutPrice,
    slot,
    createdAt,
    updatedAt,
  ];
}