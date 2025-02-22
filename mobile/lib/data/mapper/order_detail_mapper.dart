import 'package:mobile/data/models/order_detail_model.dart';
import 'package:openapi/api.dart';

class OrderDetailMapper {
  static OrderDetailModel toModel(OrderDetailDto dto) {
    return OrderDetailModel(
      orderDetailId: dto.orderDetailId!,
      orderId: dto.orderId!,
      skuId: dto.skuId!,
      originalPrice: dto.originalPrice!,
      checkoutPrice: dto.checkoutPrice!,
      slotId: dto.slotId,
      promotionalCampaignId: dto.promotionalCampaignId,
      originalProductPrice: dto.originalProductPrice!,
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
    );
  }
}
