import 'package:mobile/data/mapper/promotion_mapper.dart';
import 'package:mobile/data/mapper/sku_mapper.dart';
import 'package:mobile/data/mapper/slot_mapper.dart';
import 'package:mobile/data/models/order_detail_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/data/models/sku_model.dart';
import 'package:openapi/api.dart';

class OrderDetailMapper {
  static OrderDetailModel toModel(OrderDetailDto dto) {
    return OrderDetailModel(
      orderDetailId: dto.orderDetailId!,
      orderId: dto.orderId!,
      sku: SkuMapper.toModel(dto.sku ?? StockKeepingUnitDto()),
      quantity: dto.quantity,
      promotionalCampaign: PromotionMapper.toModel(dto.promotionalCampaign ?? PromotionalCampaignDto()),
      unitPrice: dto.unitPrice,
      subTotal: dto.subTotal,
      finalTotal: dto.finalTotal,
      slot: SlotMapper.toModel(dto.slot ?? SlotDto()),
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
    );
  }

  static OrderDetailDto toDto(OrderDetailModel model) {
    return OrderDetailDto(
      orderDetailId: model.orderDetailId,
      orderId: model.orderId,
      sku: SkuMapper.toDto(model.sku ?? StockKeepingUnitModel()),
      quantity: model.quantity,
      promotionalCampaign: PromotionMapper.toDto(model.promotionalCampaign ?? PromotionModel()),
      unitPrice: model.unitPrice,
      subTotal: model.subTotal,
      finalTotal: model.finalTotal,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
