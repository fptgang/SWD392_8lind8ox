import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:openapi/api.dart';

class PromotionMapper {
  static PromotionModel toModel(PromotionalCampaignDto? dto) {
    if (dto == null) {
      return PromotionModel(
        campaignId: null,
        title: '',
        description: '',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        discountRate: 0,
        isVisible: false,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
    }

    return PromotionModel(
      campaignId: dto.campaignId,
      title: dto.title ?? '',
      description: dto.description ?? '',
      startDate: dto.startDate ?? DateTime.now(),
      endDate: dto.endDate ?? DateTime.now(),
      discountRate: dto.discountRate ?? 0,
      isVisible: dto.isVisible ?? false,
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt,
    );
  }

  static PromotionalCampaignDto toDto(PromotionModel model) {
    return PromotionalCampaignDto(
      campaignId: model.campaignId,
      title: model.title,
      description: model.description,
      startDate: model.startDate,
      endDate: model.endDate,
      discountRate: model.discountRate,
      isVisible: model.isVisible,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}

