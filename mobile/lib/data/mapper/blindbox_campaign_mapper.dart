
import 'package:mobile/data/mapper/promotion_mapper.dart';
import 'package:mobile/data/models/blindbox_campaign_model.dart';
import 'package:openapi/api.dart';

class BlindBoxCampaignMapper{
  static BlindBoxCampaignModel toModel(BlindBoxCampaignDto dto){
    return BlindBoxCampaignModel(
      blindBoxId: dto.blindBoxId ?? 0,
      promotionalCampaign: PromotionMapper.toModel(dto.promotionalCampaign ?? PromotionalCampaignDto()),
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt,
      isVisible: dto.isVisible ?? false,
    );
  }
}