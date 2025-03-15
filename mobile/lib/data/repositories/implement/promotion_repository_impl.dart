import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/promotion_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
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
  Future<PromotionModel> getPromotionById(int id) async {
    try {
      PromotionalCampaignDto? promotionalCampaignDto =
          await _apiService.getPromotionalCampaignById(id);
      if (promotionalCampaignDto == null) {
        throw Exception(
            '[PromotionRepositoryImpl]: Cannot get promotion information');
      }
      PromotionModel promotionModel =
          PromotionMapper.toModel(promotionalCampaignDto);
      return promotionModel;
    } catch (e) {
      throw Exception(
          '[PromotionRepositoryImpl]: Cannot get promotion information');
    }
  }

  @override
  Future<PaginationResponseGeneric<PromotionModel>> getPromotions(
      Pageable pageable, String filter, String search) async {
    try {
      // Get the response from API
      GetPromotionalCampaigns200Response? response =
          await _apiService.getPromotionalCampaigns(
              pageable: pageable, filter: filter, search: search);

      // Validate the response
      if (response == null) {
        throw Exception('API returned null response');
      }

      // Log response for debugging
      debugPrint('API Response received: ${response.runtimeType}');

      try {
        // Map the response to our model
        PaginationResponseGeneric<PromotionModel> promotionModels =
            PaginationResponseMapper.toModel(
                dto: response,
                fromDTO: (data) => PromotionMapper.toModel(data));

        // Log success
        debugPrint(
            'Successfully mapped ${promotionModels.content.length} promotions');
        return promotionModels;
      } catch (mappingError) {
        // Handle mapping errors specifically
        debugPrint('Error mapping response: $mappingError');
        throw Exception('Failed to map API response: $mappingError');
      }
    } catch (e, stackTrace) {
      // Log the full error details
      debugPrint('Error fetching promotions: $e');
      debugPrint('Stacktrace: $stackTrace');
      throw Exception(
          '[PromotionRepositoryImpl]: Cannot get promotion information, error: $e, stacktrace: $stackTrace');
    }
  }
}
