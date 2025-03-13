

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/blindbox_campaign_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:openapi/api.dart';

@injectable
@Singleton()
abstract class BlindBoxCampaignRepository {
  Future<BlindBoxCampaignModel> getBlindBoxCampaignById(int id);
  Future<PaginationResponseGeneric<BlindBoxCampaignModel>> getBlindBoxCampaigns(Pageable pageable, String filter, String search);
}