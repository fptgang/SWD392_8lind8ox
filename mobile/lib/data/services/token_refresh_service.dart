import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/jwt_response_model.dart';
import 'package:mobile/data/services/token_service.dart';

@lazySingleton
class TokenRefreshService {
  final TokenService _tokenService;
  final Dio _dio;

  TokenRefreshService({
    required TokenService tokenService,
    Dio? dio,
  }) : _tokenService = tokenService,
        _dio = dio ?? Dio(BaseOptions(
          baseUrl: dotenv.env['BASE_URL'] ?? '',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ));

  Future<JwtResponseModel> refreshToken() async {
    final refreshToken = _tokenService.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      debugPrint('No refresh token available');
      await _tokenService.clearTokens();
      throw Exception('No refresh token available');
    }

    try {
      debugPrint('Attempting to refresh token with token: ${refreshToken.substring(0, min(10, refreshToken.length))}...');

      // Remove any existing authorization header to prevent sending expired tokens
      _dio.options.headers.remove('Authorization');

      // Format the request body according to your API expectations
      final response = await _dio.post(
        '/auth/refresh-token',
        data: {
          'refreshToken': refreshToken,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint('Refresh token response status: ${response.statusCode}');

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['accessToken'] != null &&
          response.data['refreshToken'] != null) {

        final accessToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String;

        // Clear existing tokens first
        await _tokenService.clearTokens();
        await Future.delayed(const Duration(milliseconds: 100));

        // Save new tokens with force write
        await _tokenService.saveTokens(accessToken, newRefreshToken, forceWrite: true);

        // Verify tokens were saved
        final savedAccessToken = _tokenService.getAccessToken();
        final savedRefreshToken = _tokenService.getRefreshToken();

        debugPrint('Token refresh verification - Access: ${savedAccessToken != null}, Refresh: ${savedRefreshToken != null}');

        if (savedAccessToken == null || savedRefreshToken == null) {
          throw Exception('Failed to save refreshed tokens');
        }

        debugPrint('Token refreshed successfully');
        return JwtResponseModel(
          accessToken: accessToken,
          refreshToken: newRefreshToken,
        );
      } else {
        debugPrint('Failed to refresh token: ${response.statusCode}');
        await _tokenService.clearTokens();
        throw Exception('Failed to refresh token: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error refreshing token: $e');
      await _tokenService.clearTokens();
      throw Exception('Token refresh failed: $e');
    }
  }

  // Utility method to handle string length safely
  int min(int a, int b) => a < b ? a : b;
}