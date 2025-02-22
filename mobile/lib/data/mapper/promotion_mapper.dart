

import 'package:mobile/data/mapper/blindbox_mapper.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:openapi/api.dart';

class PromotionMapper{
  static PromotionModel toModel(PromotionalCampaignDto dto){
    return PromotionModel(
      campaignId: dto.campaignId!,
      title: dto.title!,
      description: dto.description!,
      startDate: dto.startDate!,
      endDate: dto.endDate!,
      discountRate: dto.discountRate!,
      isVisible: dto.isVisible!,
      blindBoxes: dto.blindBoxes.map((e) => BlindBoxMapper.toModel(e)).toList(),
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
    );
  }

}