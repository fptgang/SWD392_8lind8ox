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
      blindBoxes: [],
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
    );
  }
}
