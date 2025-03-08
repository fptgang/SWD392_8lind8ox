import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:openapi/api.dart';

class PromotionMapper {
  static PromotionModel toModel(PromotionalCampaignDto dto) {
    return PromotionModel(
      campaignId: dto.campaignId!,
      title: dto.title!,
      description: dto.description!,
      startDate: dto.startDate!,
      endDate: dto.endDate!,
      discountRate: dto.discountRate!,
      isVisible: dto.isVisible!,
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
    );
  }

  static PromotionalCampaignDto toDto(PromotionModel model) {
    return PromotionalCampaignDto(
      campaignId: model.campaignId!,
      title: model.title!,
      description: model.description!,
      startDate: model.startDate!,
      endDate: model.endDate!,
      discountRate: model.discountRate,
      isVisible: model.isVisible!,
      createdAt: model.createdAt!,
      updatedAt: model.updatedAt,
    );
  }
}
