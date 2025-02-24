

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

import '../promotion_repository.dart';

class PromotionRepositoryImpl implements PromotionRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  PromotionRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<PromotionModel> getPromotionById(int id) {
    // TODO: implement getPromotionById
    throw UnimplementedError();
  }

  @override
  Future<PaginationResponseGeneric<GetPromotionalCampaigns200Response>> getPromotions(Pageable pageable, String filter, String search) {
    // TODO: implement getPromotions
    throw UnimplementedError();
  }
  

}