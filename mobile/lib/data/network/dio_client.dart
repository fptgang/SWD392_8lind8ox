import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/services/token_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static Dio createDio() {
    try {
      final tokenService = getIt<TokenService>();

      debugPrint('Creating Dio client. Has token: ${tokenService.hasTokens()}');

      final dio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['BASE_URL'] ?? '',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // Set authorization header if token exists and is not empty
      final authHeader = tokenService.getAuthorizationHeader();
      if (authHeader != null && authHeader.isNotEmpty) {
        debugPrint('Setting initial Authorization header: ${authHeader.substring(0, min(20, authHeader.length))}...');
        dio.options.headers['Authorization'] = authHeader;
      } else {
        // Remove any existing Authorization header if no valid token
        dio.options.headers.remove('Authorization');
        debugPrint('No valid auth token available, not adding Authorization header');
      }

      // Add token refresh interceptor
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Add token to every request if available
            final currentAuthHeader = tokenService.getAuthorizationHeader();
            if (currentAuthHeader != null && currentAuthHeader.isNotEmpty) {
              debugPrint('Request to ${options.path}: Adding auth header');
              options.headers['Authorization'] = currentAuthHeader;
            } else {
              options.headers.remove('Authorization');
              debugPrint('Request to ${options.path}: No valid auth token, removing Authorization header');
            }
            return handler.next(options);
          },
          onError: (error, handler) async {
            if (error.response?.statusCode == 401) {
              debugPrint('401 error detected on ${error.requestOptions.path}, attempting token refresh');

              if (error.requestOptions.path.contains('/auth/refresh-token')) {
                debugPrint('Token refresh endpoint returned 401, clearing tokens and not retrying');
                await tokenService.clearTokens();
                return handler.next(error);
              }

              try {
                final refreshToken = tokenService.getRefreshToken();

                if (refreshToken == null || refreshToken.isEmpty) {
                  debugPrint('No refresh token available, cannot refresh');
                  await tokenService.clearTokens();
                  return handler.next(error);
                }

                debugPrint('Refresh token found, attempting refresh');

                // Create a new Dio instance to avoid interceptor loops
                final refreshDio = Dio(BaseOptions(
                  baseUrl: dotenv.env['BASE_URL'] ?? '',
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                  },
                ));

                // Format the request according to API expectations
                final response = await refreshDio.post(
                  '/auth/refresh-token',
                  data: {
                    'refreshToken': refreshToken,
                  },
                );

                debugPrint('Refresh response received. Status: ${response.statusCode}');

                if (response.statusCode == 200 &&
                    response.data != null &&
                    response.data['accessToken'] != null &&
                    response.data['refreshToken'] != null) {

                  final accessToken = response.data['accessToken'] as String;
                  final newRefreshToken = response.data['refreshToken'] as String;

                  if (accessToken.isEmpty || newRefreshToken.isEmpty) {
                    debugPrint('🔴 Received empty tokens from refresh endpoint');
                    await tokenService.clearTokens();
                    return handler.next(error);
                  }

                  debugPrint('Token refresh successful, saving new tokens');

                  await tokenService.saveTokens(
                      accessToken,
                      newRefreshToken,
                      forceWrite: true
                  );

                  final newAuthHeader = accessToken;
                  debugPrint('Setting new authorization header for retry: ${newAuthHeader.substring(0, min(20, newAuthHeader.length))}...');

                  error.requestOptions.headers['Authorization'] = newAuthHeader;

                  final opts = Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  );

                  debugPrint('Retrying original request to: ${error.requestOptions.path}');
                  final cloneReq = await dio.request(
                    error.requestOptions.path,
                    options: opts,
                    data: error.requestOptions.data,
                    queryParameters: error.requestOptions.queryParameters,
                  );

                  debugPrint('Retry successful');
                  return handler.resolve(cloneReq);
                } else {
                  debugPrint('Token refresh failed. Status: ${response.statusCode}, Data: ${response.data}');
                  await tokenService.clearTokens();
                }
              } catch (e) {
                debugPrint('Token refresh failed with error: $e');
                await tokenService.clearTokens();
              }
            }

            return handler.next(error);
          },
        ),
      );

      // Add logging interceptor for debug mode
      if (kDebugMode) {
        dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
        ));
      }

      return dio;
    } catch (e) {
      debugPrint('Error creating Dio client: $e');
      // Return a basic Dio instance as fallback
      return Dio(BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
      ));
    }
  }

  static int min(int a, int b) => a < b ? a : b;
}