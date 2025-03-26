import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/set_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/set_model.dart';
import 'package:mobile/data/repositories/set_repository.dart';
import 'package:mobile/data/services/token_refresh_service.dart';
import 'package:mobile/data/services/token_service.dart';
import 'package:mobile/base/repository/base_repository.dart';
import 'package:openapi/api.dart';

String token = dotenv.env['TOKEN'] ?? '';

class SetRepositoryImpl extends BaseRepository implements SetRepository {
  final Box box;
  final DefaultApi _apiService;
  final TokenService? _tokenService;
  final TokenRefreshService? _tokenRefreshService;

  SetRepositoryImpl({
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
          'Setting sets auth header with token service: ${authToken != null ? "exists" : "null"}');
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
      debugPrint('Set Authorization header for sets: $authHeader');
    } else {
      debugPrint('WARNING: No valid auth token available for set repository');
    }
  }

  @override
  Future<SetModel> getSetById(int id) async {
    try {
      SetDto? setDto = await _apiService.getSetById(id);
      if (setDto == null) {
        throw Exception("Set not found");
      }
      SetModel setModel = SetMapper.toModel(setDto);
      return setModel;
    } catch (e) {
      debugPrint('[SetRepositoryImpl] getSetById: $e');
      throw Exception("Failed to get set");
    }
  }

  @override
  Future<PaginationResponseGeneric<SetModel>> getSets(
      Pageable pageable, String filter, String search) async {
    return handleApiRequest<PaginationResponseGeneric<SetModel>>(() async {
      debugPrint(
          '[SetRepositoryImpl] Getting sets with pageable: ${pageable.page}, size: ${pageable.size}, filter: $filter, search: $search');

      try {
        GetSets200Response? response = await _apiService.getSets(
            pageable: pageable, filter: filter, search: search);

        if (response == null) {
          debugPrint('[SetRepositoryImpl] API returned null response');
          throw Exception('API returned null response for getSets');
        }

        debugPrint(
            '[SetRepositoryImpl] Successfully got sets response with ${response.content.length} items');

        PaginationResponseGeneric<SetModel> setModels =
            PaginationResponseMapper.toModel(
                dto: response, fromDTO: (data) => SetMapper.toModel(data));

        return setModels;
      } catch (e, stackTrace) {
        debugPrint('[SetRepositoryImpl] Error getting sets: $e');
        debugPrint('[SetRepositoryImpl] Stack trace: $stackTrace');

        // Attempt to refresh token if there's a token service and the error is 401
        if (e is ApiException &&
            e.code == 401 &&
            _tokenRefreshService != null) {
          debugPrint(
              '[SetRepositoryImpl] Attempting to refresh token due to 401 error');
          await _tokenRefreshService!.refreshToken();
          _refreshAuthHeader();

          // Retry the request after token refresh
          GetSets200Response? retryResponse = await _apiService.getSets(
              pageable: pageable, filter: filter, search: search);

          if (retryResponse != null) {
            debugPrint(
                '[SetRepositoryImpl] Successfully retrieved sets after token refresh');
            return PaginationResponseMapper.toModel(
                dto: retryResponse, fromDTO: (data) => SetMapper.toModel(data));
          }
        }

        throw Exception('Failed to get sets: ${e.toString()}');
      }
    });
  }
}
