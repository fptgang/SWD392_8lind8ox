

import 'package:mobile/data/models/promotional_campaign_model.dart';

class BlindBoxCampaignModel{
  final int? blindBoxId;
  final PromotionModel? promotionalCampaign;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isVisible;

  BlindBoxCampaignModel({
    this.blindBoxId,
    this.promotionalCampaign,
    this.createdAt,
    this.updatedAt,
    this.isVisible,
  });
}