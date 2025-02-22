

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:openapi/api.dart';

@injectable
@Singleton()
abstract class PromotionRepository {
  Future<PromotionModel> getPromotionById(int id);
  Future<PaginationResponseGeneric<GetPromotionalCampaigns200Response>> getPromotions(Pageable pageable, String filter, String search);
}