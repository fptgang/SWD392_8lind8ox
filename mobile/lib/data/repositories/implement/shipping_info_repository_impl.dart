import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/shipping_info_mapper.dart';
import 'package:mobile/data/models/create_shipping_info_model.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/shipping_info_model.dart';
import 'package:mobile/data/repositories/shipping_info_repository.dart';
import 'package:mobile/data/services/token_refresh_service.dart';
import 'package:mobile/data/services/token_service.dart';
import 'package:openapi/api.dart';

class ShippingInfoRepositoryImpl implements ShippingInfoRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();
  final TokenService _tokenService = getIt<TokenService>();
  final TokenRefreshService _tokenRefreshService = getIt<TokenRefreshService>();

  ShippingInfoRepositoryImpl() {
    _refreshAuthHeader();
  }

  void _refreshAuthHeader() {
    final token = _tokenService.getAccessToken();
    debugPrint(
        'Setting shipping info auth header with token: ${token != null ? "exists" : "null"}');

    if (token != null && token.isNotEmpty) {
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      _apiService.apiClient.addDefaultHeader("Authorization", authHeader);
      debugPrint('Set Authorization header: $authHeader');
    } else {
      debugPrint(
          'WARNING: No valid token available for shipping info repository');
      // Fall back to box get if token service failed
      final fallbackToken = box.get('loginToken');
      if (fallbackToken != null && fallbackToken.isNotEmpty) {
        final authHeader = fallbackToken.startsWith('Bearer ')
            ? fallbackToken
            : 'Bearer $fallbackToken';
        _apiService.apiClient.addDefaultHeader("Authorization", authHeader);
        debugPrint('Set fallback Authorization header: $authHeader');
      }
    }
  }

  Future<T> _executeWithTokenRefresh<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (e) {
      // Check if this is an auth error (assuming API returns 401 for unauthorized)
      if (e is ApiException && e.code == 401) {
        debugPrint('Token expired, attempting to refresh token');

        try {
          // Try to refresh the token
          await _tokenRefreshService.refreshToken();

          // Update the auth header with new token
          _refreshAuthHeader();

          // Retry the API call
          return await apiCall();
        } catch (refreshError) {
          debugPrint('Token refresh failed: $refreshError');
          throw Exception('Authentication failed. Please log in again.');
        }
      }

      // If not auth error or refresh failed, rethrow
      rethrow;
    }
  }

  @override
  Future<ShippingInfoModel> createShippingInfo(
      CreateShippingInfoModel shippingInfo) async {
    return _executeWithTokenRefresh(() async {
      try {
        debugPrint('Creating shipping info: $shippingInfo');
        ShippingInfoDto? shippingInfoDto = await _apiService.createShippingInfo(
            ShippingInfoMapper.fromCreateToDto(shippingInfo));
        debugPrint('Shipping info created: $shippingInfoDto');
        if (shippingInfoDto == null) {
          throw Exception('Cannot create shipping info information');
        }
        ShippingInfoModel shippingInfoModel =
            ShippingInfoMapper.toModel(shippingInfoDto);
        return shippingInfoModel;
      } catch (e, stacktrace) {
        debugPrint('Error creating shipping info: $e, stackTrace: $stacktrace');
        throw Exception('Cannot create shipping info information: $e');
      }
    });
  }

  @override
  Future<ShippingInfoModel> getShippingInfoById(int id) async {
    return _executeWithTokenRefresh(() async {
      try {
        ShippingInfoDto? shippingInfoDto =
            await _apiService.getShippingInfoById(id);
        if (shippingInfoDto == null) {
          throw Exception('Cannot get shipping info information');
        }
        ShippingInfoModel shippingInfoModel =
            ShippingInfoMapper.toModel(shippingInfoDto);
        return shippingInfoModel;
      } catch (e) {
        throw Exception(
          'Cannot get shipping info information, $e',
        );
      }
    });
  }

  @override
  Future<PaginationResponseGeneric<ShippingInfoModel>>
      getShippingInfos() async {
    return _executeWithTokenRefresh(() async {
      try {
        debugPrint(
            "Authorization header: ${_apiService.apiClient.defaultHeaderMap["Authorization"]}");
        GetShippingInfos200Response? response =
            await _apiService.getShippingInfos();
        debugPrint('Shipping info response: $response');
        if (response == null) {
          throw Exception('Cannot get shipping info information');
        }
        PaginationResponseGeneric<ShippingInfoModel>? shippingInfoModels =
            PaginationResponseMapper.toModel(
                dto: response,
                fromDTO: (data) => ShippingInfoMapper.toModel(data));
        return shippingInfoModels;
      } catch (e, stackTrace) {
        throw Exception(
          'Cannot get shipping info information, $e, stackTrace: $stackTrace',
        );
      }
    });
  }
}
