import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/services/token_refresh_service.dart';
import 'package:mobile/data/services/token_service.dart';

abstract class BaseRepository {
  final TokenService _tokenService = getIt<TokenService>();
  final TokenRefreshService _tokenRefreshService = getIt<TokenRefreshService>();

  /// Helper method to handle API requests with automatic token refresh
  Future<T> handleApiRequest<T>(Future<T> Function() apiCall) async {
    try {
      debugPrint('🟢 Executing API request');
      return await apiCall();
    } catch (e) {
      debugPrint('🔴 API request failed: $e');
      
      if (e is DioException && e.response?.statusCode == 401) {
        debugPrint('🟠 Received 401 error, attempting token refresh');
        
        try {
          // Get refresh token
          final refreshToken = _tokenService.getRefreshToken();
          
          if (refreshToken == null || refreshToken.isEmpty) {
            debugPrint('🔴 No refresh token available for refresh attempt');
            throw Exception('Authentication required: No refresh token available');
          }
          
          debugPrint('🟠 Attempting to refresh token');
          
          // Use the token refresh service
          final refreshResult = await _tokenRefreshService.refreshToken();
          
          debugPrint('🟢 Token refreshed successfully, retrying API call');
          
          // Retry the original request
          return await apiCall();
        } catch (refreshError) {
          debugPrint('🔴 Token refresh failed: $refreshError');
          // Clear tokens since refresh failed
          await _tokenService.clearTokens();
          throw Exception('Session expired. Please log in again.');
        }
      } else if (e is DioException) {
        debugPrint('🔴 API request failed with status code: ${e.response?.statusCode}, message: ${e.message}');
        throw Exception('API Error: ${e.message}');
      }
      
      // Rethrow original error if not handled
      rethrow;
    }
  }
}
