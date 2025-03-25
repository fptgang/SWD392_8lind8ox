import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/models/jwt_response_model.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/utils/enum/enum.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final AuthRepository _authRepository;
  bool _isRefreshing = false;
  final _pendingRequests = <RequestOptions, Completer<Response<dynamic>>>{};
  var box = Hive.box('authentication');

  AuthInterceptor(this._dio, this._authRepository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Skip adding auth header for token refresh endpoint
    if (options.path.contains('/auth/refresh-token')) {
      debugPrint('Skipping auth header for refresh token request');
      return handler.next(options);
    }

    // Get token for all other requests
    final token = box.get('loginToken');
    if (token != null && token.toString().isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint(
          'Added auth header: Bearer ${token.toString().substring(0, _min(10, token.toString().length))}...');
    } else {
      debugPrint('No auth token available for request');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      debugPrint('Received 401 error, attempting to refresh token');
      final requestOptions = err.requestOptions;

      // Skip token refresh for auth endpoints to avoid infinite loops
      if (requestOptions.path.contains('/auth/login') ||
          requestOptions.path.contains('/auth/refresh-token') ||
          requestOptions.path.contains('/auth/logout')) {
        debugPrint('Auth endpoint returned 401, not attempting token refresh');
        _clearTokensAndNotify();
        return handler.next(err);
      }

      // Save the request for later retry
      final completer = Completer<Response<dynamic>>();
      _pendingRequests[requestOptions] = completer;

      try {
        _isRefreshing = true;
        final refreshToken = box.get('refreshToken');

        if (refreshToken == null || refreshToken.toString().isEmpty) {
          debugPrint('No refresh token available, cannot refresh');
          _clearTokensAndNotify();
          return handler.next(err);
        }

        debugPrint(
            'Attempting to refresh token with refresh token: ${refreshToken.toString().substring(0, _min(10, refreshToken.toString().length))}...');

        // Attempt to refresh the token
        final jwtResponse =
            await _authRepository.refreshToken(refreshToken.toString());

        if (jwtResponse.accessToken == null ||
            jwtResponse.accessToken!.isEmpty) {
          debugPrint('Token refresh failed: Empty access token returned');
          _clearTokensAndNotify();
          return handler.next(err);
        }

        debugPrint(
            'Token refresh successful, retrying requests with new token');

        // Retry all pending requests with new token
        await _retryPendingRequests(jwtResponse.accessToken!);

        // Retry the current request
        final response =
            await _retryRequest(requestOptions, jwtResponse.accessToken!);
        handler.resolve(response);
      } catch (e) {
        debugPrint('Token refresh failed: $e');
        _clearTokensAndNotify();
        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      return handler.next(err);
    }
  }

  Future<void> _retryPendingRequests(String newToken) async {
    debugPrint(
        'Retrying ${_pendingRequests.length} pending requests with new token');

    for (final request in _pendingRequests.keys) {
      final completer = _pendingRequests[request]!;
      try {
        final response = await _retryRequest(request, newToken);
        completer.complete(response);
      } catch (e) {
        completer.completeError(e);
      }
    }
    _pendingRequests.clear();
  }

  Future<Response> _retryRequest(
      RequestOptions requestOptions, String newToken) async {
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newToken',
      },
    );

    debugPrint('Retrying request to: ${requestOptions.path}');
    return await _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  void _clearTokensAndNotify() {
    // Clear tokens and mark as unauthenticated
    debugPrint('Clearing tokens due to authentication failure');
    box.delete('loginToken');
    box.delete('refreshToken');
    _authRepository.updateAuthStatus(AuthenticationStatus.unauthenticated);

    // Clear any pending requests
    for (final completer in _pendingRequests.values) {
      completer.completeError(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Authentication failed',
        type: DioExceptionType.unknown,
      ));
    }
    _pendingRequests.clear();
  }

  // Utility method to handle string length safely
  int _min(int a, int b) => a < b ? a : b;
}
