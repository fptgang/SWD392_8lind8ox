import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/base/repository/base_repository.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/models/blindbox_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/services/token_refresh_service.dart';
import 'package:mobile/data/services/token_service.dart';
import 'package:openapi/api.dart';

import '../../../app/di/injection.dart';
import '../../mapper/blindbox_mapper.dart';
import '../blindbox_repository.dart';

String token = dotenv.env['TOKEN'] ?? '';

class BlindBoxRepositoryImpl extends BaseRepository
    implements BlindBoxRepository {
  final Box box;
  final DefaultApi _apiService;
  final TokenService _tokenService;
  final TokenRefreshService _tokenRefreshService;

  BlindBoxRepositoryImpl({
    Box? box,
    DefaultApi? apiService,
    TokenService? tokenService,
    TokenRefreshService? tokenRefreshService,
  })  : box = box ?? Hive.box('authentication'),
        _apiService = apiService ?? getIt<DefaultApi>(),
        _tokenService = tokenService ?? getIt<TokenService>(),
        _tokenRefreshService =
            tokenRefreshService ?? getIt<TokenRefreshService>() {
    _refreshAuthHeader();
  }

  void _refreshAuthHeader() {
    final token = _tokenService.getAccessToken();
    debugPrint(
        'Setting blindbox auth header with token: ${token != null ? "exists" : "null"}');

    if (token != null && token.isNotEmpty) {
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      _apiService.apiClient.addDefaultHeader("Authorization", authHeader);
      debugPrint('Set Authorization header: $authHeader');
    } else {
      debugPrint('WARNING: No valid token available for blindbox repository');
      // Fall back to box get if token service failed
      final fallbackToken = box.get('loginToken');
      if (fallbackToken != null && fallbackToken.isNotEmpty) {
        final authHeader = fallbackToken.toString().startsWith('Bearer ')
            ? fallbackToken.toString()
            : 'Bearer $fallbackToken';
        _apiService.apiClient.addDefaultHeader("Authorization", authHeader);
        debugPrint('Set fallback Authorization header: $authHeader');
      }
    }
  }

  @override
  Future<BlindBoxModel> getBlindBoxById(int id) async {
    return handleApiRequest<BlindBoxModel>(() async {
      final blindBoxDto = await _apiService.getBlindBoxById(id);

      if (blindBoxDto == null) {
        throw Exception("Cannot get blindbox information");
      }

      final blindBoxModel = BlindBoxMapper.toModel(blindBoxDto);
      return blindBoxModel;
    });
  }

  @override
  Future<PaginationResponseGeneric<BlindBoxModel>> getBlindBoxes(
      Pageable pageable, String filter, String search) async {
    return handleApiRequest<PaginationResponseGeneric<BlindBoxModel>>(() async {
      final blindBoxes = await _apiService.getBlindBoxes(
          pageable: pageable, filter: filter, search: search);

      if (blindBoxes == null) {
        throw Exception("Cannot get blind boxes");
      }

      final blindBoxModels = PaginationResponseMapper.toModel(
        dto: blindBoxes,
        fromDTO: (data) => BlindBoxMapper.toModel(data),
      );

      debugPrint(
          '[BlindBox Repository Impl]: get blind boxes: ${blindBoxModels.content}');
      return blindBoxModels;
    });
  }
}
