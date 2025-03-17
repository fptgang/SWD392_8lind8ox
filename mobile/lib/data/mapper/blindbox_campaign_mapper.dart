
import 'package:mobile/data/mapper/promotion_mapper.dart';
import 'package:mobile/data/models/blindbox_campaign_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:openapi/api.dart';

class BlindBoxCampaignMapper{
  static BlindBoxCampaignModel toModel(BlindBoxCampaignDto dto){
    return BlindBoxCampaignModel(
      blindBoxId: dto.blindBoxId ?? 0,
      promotionalCampaignId: dto.promotionalCampaignId,
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt,
      isVisible: dto.isVisible ?? false,
    );
  }
  static BlindBoxCampaignDto toDto(BlindBoxCampaignModel model) {
    return BlindBoxCampaignDto(
      blindBoxId: model.blindBoxId,
      promotionalCampaignId: model.promotionalCampaignId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isVisible: model.isVisible,
    );
  }

}