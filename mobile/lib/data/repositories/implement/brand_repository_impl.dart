import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/repository/base_repository.dart';
import 'package:mobile/data/mapper/brand_mapper.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/models/brand_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/services/token_refresh_service.dart';
import 'package:mobile/data/services/token_service.dart';
import 'package:openapi/api.dart';

import '../brand_repository.dart';

class BrandRepositoryImpl extends BaseRepository implements BrandRepository {
  final Box box;
  final DefaultApi _apiService;
  final TokenService _tokenService;
  final TokenRefreshService _tokenRefreshService;

  BrandRepositoryImpl({
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
        'Setting brand auth header with token: ${token != null ? "exists" : "null"}');

    if (token != null && token.isNotEmpty) {
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      _apiService.apiClient.addDefaultHeader("Authorization", authHeader);
      debugPrint('Set Authorization header: $authHeader');
    } else {
      debugPrint('WARNING: No valid token available for brand repository');
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
  Future<BrandModel> getBrandById(int id) async {
    return handleApiRequest<BrandModel>(() async {
      BrandDto? brandDto = await _apiService.getBrandById(id);
      if (brandDto == null) throw Exception("Brand not found");
      return BrandMapper.toModel(brandDto);
    });
  }

  @override
  Future<PaginationResponseGeneric<BrandModel>> getBrands(
      Pageable pageable, String filter, String search) async {
    return handleApiRequest<PaginationResponseGeneric<BrandModel>>(() async {
      GetBrands200Response? response = await _apiService.getBrands(
          pageable: pageable, filter: filter, search: search);
      if (response == null) throw Exception("Brands not found");
      PaginationResponseGeneric<BrandModel> brandsResponseModel =
          PaginationResponseMapper.toModel(
        dto: response,
        fromDTO: (data) => BrandMapper.toModel(data),
      );
      return brandsResponseModel;
    });
  }
}
