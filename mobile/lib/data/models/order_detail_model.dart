class OrderDetailModel {
  final int orderDetailId;
  final int orderId;
  final int skuId;
  final double originalPrice;
  final double? checkoutPrice;
  final int? slotId;
  final int? promotionalCampaignId;
  final double? originalProductPrice;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderDetailModel({
    required this.orderDetailId,
    required this.orderId,
    required this.skuId,
    required this.originalPrice,
    this.checkoutPrice,
    this.slotId,
    this.promotionalCampaignId,
    this.originalProductPrice,
    required this.createdAt,
    this.updatedAt,
  });

  List<Object?> get props => [
    orderDetailId,
    orderId,
    skuId,
    originalPrice,
    checkoutPrice,
    slotId,
    promotionalCampaignId,
    originalProductPrice,
    createdAt,
    updatedAt,
  ];
}