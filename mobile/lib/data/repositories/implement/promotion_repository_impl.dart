import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/repository/base_repository.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/promotion_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/promotional_campaign_model.dart';
import 'package:mobile/data/services/token_refresh_service.dart';
import 'package:mobile/data/services/token_service.dart';
import 'package:openapi/api.dart';

import '../promotion_repository.dart';

String token = dotenv.env['TOKEN'] ?? '';

class PromotionRepositoryImpl extends BaseRepository
    implements PromotionRepository {
  final Box box;
  final DefaultApi _apiService;
  final TokenService? _tokenService;
  final TokenRefreshService? _tokenRefreshService;

  PromotionRepositoryImpl({
    Box? box,
    DefaultApi? apiService,
    TokenService? tokenService,
    TokenRefreshService? tokenRefreshService,
  })  : box = box ?? Hive.box('authentication'),
        _apiService = apiService ?? getIt<DefaultApi>(),
        _tokenService = tokenService ??
            (getIt.isRegistered<TokenService>() ? getIt<TokenService>() : null),
        _tokenRefreshService = tokenRefreshService ??
            (getIt.isRegistered<TokenRefreshService>()
                ? getIt<TokenRefreshService>()
                : null) {
    _refreshAuthHeader();
  }

  void _refreshAuthHeader() {
    String? authToken;

    // Try to get token from TokenService first
    if (_tokenService != null) {
      authToken = _tokenService!.getAccessToken();
      debugPrint(
          'Setting promotion auth header with token service: ${authToken != null ? "exists" : "null"}');
    }

    // Fallback to box if token service failed or returned null
    if (authToken == null) {
      authToken = box.get('loginToken');
      debugPrint(
          'Falling back to box for auth token: ${authToken != null ? "exists" : "null"}');
    }

    if (authToken != null && authToken.isNotEmpty) {
      final authHeader =
          authToken.startsWith('Bearer ') ? authToken : 'Bearer $authToken';
      _apiService.apiClient.addDefaultHeader("Authorization", authHeader);
      debugPrint('Set Authorization header for promotions: $authHeader');
    } else {
      debugPrint(
          'WARNING: No valid auth token available for promotion repository');
    }
  }

  @override
  Future<PromotionModel> getPromotionById(int id) async {
    return handleApiRequest<PromotionModel>(() async {
      debugPrint('[PromotionRepositoryImpl] Getting promotion with id: $id');

      final promotionalCampaignDto =
          await _apiService.getPromotionalCampaignById(id);

      if (promotionalCampaignDto == null) {
        throw Exception('API returned null for promotion ID: $id');
      }

      final promotionModel = PromotionMapper.toModel(promotionalCampaignDto);
      debugPrint(
          '[PromotionRepositoryImpl] Successfully retrieved promotion: ${promotionModel.title}');
      return promotionModel;
    });
  }

  @override
  Future<PaginationResponseGeneric<PromotionModel>> getPromotions(
      Pageable pageable, String filter, String search) async {
    return handleApiRequest<PaginationResponseGeneric<PromotionModel>>(
        () async {
      debugPrint(
          '[PromotionRepositoryImpl] Getting promotions with pageable: ${pageable.page}, size: ${pageable.size}, filter: $filter, search: $search');

      // Get the response from API
      final response = await _apiService.getPromotionalCampaigns(
          pageable: pageable, filter: filter, search: search);

      // Validate the response
      if (response == null) {
        debugPrint('[PromotionRepositoryImpl] API returned null response');
        throw Exception('API returned null response for getPromotions');
      }

      // Log response for debugging
      debugPrint(
          '[PromotionRepositoryImpl] API Response received with ${response.content.length} items');

      try {
        // Map the response to our model
        final promotionModels = PaginationResponseMapper.toModel(
            dto: response, fromDTO: (data) => PromotionMapper.toModel(data));

        // Log success
        debugPrint(
            '[PromotionRepositoryImpl] Successfully mapped ${promotionModels.content.length} promotions');
        return promotionModels;
      } catch (mappingError, stackTrace) {
        // Handle mapping errors specifically
        debugPrint(
            '[PromotionRepositoryImpl] Error mapping response: $mappingError');
        debugPrint('[PromotionRepositoryImpl] Stack trace: $stackTrace');
        throw Exception('Failed to map API response: $mappingError');
      }
    });
  }
}
