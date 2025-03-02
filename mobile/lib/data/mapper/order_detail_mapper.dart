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

  static OrderDetailDto toDto(OrderDetailModel model) {
    return OrderDetailDto(
      orderDetailId: model.orderDetailId,
      orderId: model.orderId,
      skuId: model.skuId,
      originalPrice: model.originalPrice,
      checkoutPrice: model.checkoutPrice,
      slotId: model.slotId,
      promotionalCampaignId: model.promotionalCampaignId,
      originalProductPrice: model.originalProductPrice,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
