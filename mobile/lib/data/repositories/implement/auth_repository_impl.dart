import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/data/mapper/auth_response_mapper.dart';
import 'package:mobile/data/mapper/jwt_response_mapper.dart';
import 'package:mobile/data/models/auth_response_model.dart';
import 'package:mobile/data/models/jwt_response_model.dart';
import 'package:openapi/api.dart';

import '../../../utils/enum/enum.dart';
import '../auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _controller = StreamController<AuthenticationStatus>.broadcast();
  var box = Hive.box('authentication');

  Stream<AuthenticationStatus> get status async* {
    // Check for stored token first
    final storedToken = box.get('loginToken');
    if (storedToken != null && storedToken.toString().isNotEmpty) {
      try {
        // Make a simple API call to verify token validity
        debugPrint('Checking token validity...');
        await _apiService.getCurrentUser();
        debugPrint('Token is valid, setting authenticated status');
        _controller.add(AuthenticationStatus.authenticated);
      } catch (e) {
        debugPrint('Token validation failed: $e');
        // Only set to unauthenticated if it's an auth error (401)
        if (e.toString().contains('401')) {
          _controller.add(AuthenticationStatus.unauthenticated);
        }
      }
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
    }

    yield* _controller.stream;
  }

  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }

  final DefaultApi _apiService = getIt<DefaultApi>();

  AuthRepositoryImpl() {
    if (box.get('loginToken') != null) {
      _apiService.apiClient
          .addDefaultHeader("Authorization", "Bearer ${box.get('loginToken')}");
    }
  }

  @override
  Future<AuthResponseModel> login(LoginRequestDto loginRequestDto) async {
    try {
      debugPrint('Attempting login with email: ${loginRequestDto.email}');

      // Clear any existing tokens before login
      await _clearTokens();

      AuthResponseDto? dto = await _apiService.login(loginRequestDto);

      if (dto == null) {
        debugPrint('Login failed: No response from server');
        throw Exception('Login failed: No response from server');
      }

      if (dto.token == null || dto.token!.isEmpty) {
        debugPrint('Login failed: No token received');
        throw Exception('Login failed: No token received');
      }

      debugPrint('Login successful, storing tokens');
      await _saveTokens(dto.token!, dto.refreshToken);

      _apiService.apiClient
          .addDefaultHeader("Authorization", "Bearer ${dto.token}");

      debugPrint('Setting authentication status to authenticated');
      _controller.add(AuthenticationStatus.authenticated);

      return AuthMapper.toModel(dto);
    } catch (e, stackTrace) {
      debugPrint('Login error: $e');
      debugPrint('Stack trace: $stackTrace');
      // If login fails, ensure tokens are cleared
      await _clearTokens();
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Helper method to save tokens with proper error handling
  Future<void> _saveTokens(String accessToken, String? refreshToken) async {
    try {
      if (accessToken.isEmpty) {
        debugPrint('Warning: Attempted to save empty access token');
        return;
      }

      debugPrint(
          'Saving access token: ${accessToken.substring(0, _min(10, accessToken.length))}...');
      await box.put("loginToken", accessToken);

      if (refreshToken != null && refreshToken.isNotEmpty) {
        debugPrint(
            'Saving refresh token: ${refreshToken.substring(0, _min(10, refreshToken.length))}...');
        await box.put("refreshToken", refreshToken);
      } else {
        debugPrint('Warning: No refresh token to save');
      }

      await box.flush();

      // Verify tokens were saved
      final savedAccessToken = box.get('loginToken');
      final savedRefreshToken = box.get('refreshToken');

      debugPrint(
          'Tokens saved - Access: ${savedAccessToken != null}, Refresh: ${savedRefreshToken != null}');
    } catch (e) {
      debugPrint('Error saving tokens: $e');
      throw Exception('Failed to save authentication tokens');
    }
  }

  // Utility method to get minimum of two integers
  int _min(int a, int b) => a < b ? a : b;

  // Helper method to clear tokens with proper error handling
  Future<void> _clearTokens() async {
    try {
      debugPrint('Clearing tokens');
      await box.delete('loginToken');
      await box.delete('refreshToken');
      await box.flush();

      // Clear authorization header from API client
      _apiService.apiClient.defaultHeaderMap.remove('Authorization');

      debugPrint('Tokens cleared successfully');
    } catch (e) {
      debugPrint('Error clearing tokens: $e');
      // Continue even if there's an error
    }
  }

  @override
  Future<AuthResponseModel> loginWithGoogle(String token) async {
    try {
      AuthResponseDto? dto = await _apiService.loginWithGoogle(token);
      debugPrint("dto: $dto");
      debugPrint("token from repo: $token");
      if (dto == null) {
        throw Exception('Login failed, please try again');
      }
      await Future.delayed(
        const Duration(milliseconds: 300),
        () => _controller.add(AuthenticationStatus.authenticated),
      );
      return AuthMapper.toModel(dto);
    } catch (e) {
      throw Exception(
          'Login with google failed at repository, please try again, ${e.toString()}');
    }
  }

  @override
  void logout() async {
    try {
      await _apiService.logout();
      debugPrint('Logout success');
      await _clearTokens();
      _controller.add(AuthenticationStatus.unauthenticated);
    } catch (e) {
      debugPrint('Logout error: $e');
      // Even if the API call fails, clear tokens and set status to unauthenticated
      await _clearTokens();
      _controller.add(AuthenticationStatus.unauthenticated);
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<JwtResponseModel> refreshToken(String refreshToken) async {
    try {
      debugPrint('Attempting to refresh token');

      // Don't send Authorization header with the refresh request
      _apiService.apiClient.defaultHeaderMap.remove('Authorization');

      JwtResponseDto? dto = await _apiService.refreshToken(refreshToken);

      if (dto == null || dto.accessToken == null || dto.accessToken!.isEmpty) {
        debugPrint('Token refresh failed: Invalid response');
        await _clearTokens();
        _controller.add(AuthenticationStatus.unauthenticated);
        throw Exception('Session expired, please login again');
      }

      debugPrint('Token refresh successful, storing new tokens');
      await _saveTokens(dto.accessToken!, dto.refreshToken);

      // Update API client with new token
      _apiService.apiClient
          .addDefaultHeader("Authorization", "Bearer ${dto.accessToken}");

      _controller.add(AuthenticationStatus.authenticated);
      return JwtMapper.toModel(dto);
    } catch (e) {
      debugPrint('Token refresh error: $e');
      await _clearTokens();
      _controller.add(AuthenticationStatus.unauthenticated);
      throw Exception('Session expired, please login again');
    }
  }

  @override
  void register(RegisterRequestDto registerRequestDto) async {
    try {
      debugPrint('RegisterSubmitted auth repo impl: $registerRequestDto');
      await _apiService.register(registerRequestDto);
      debugPrint('RegisterSubmitted auth repo impl');
    } catch (e) {
      debugPrint('RegisterSubmitted auth repo impl error: $registerRequestDto');
      throw Exception('Register failed, please try again, ${e.toString()}');
    }
  }

  @override
  void forgotPassword(ForgotPasswordRequestDto forgotPasswordRequestDto) async {
    try {
      await _apiService.forgotPassword(forgotPasswordRequestDto);
      debugPrint('Forgot password success repo impl');
    } catch (e) {
      throw Exception(
          'Forgot password failed, please try again, ${e.toString()}');
    }
  }

  @override
  void resetPassword(ResetPasswordRequestDto resetPasswordRequestDto) async {
    try {
      await _apiService.resetPassword(resetPasswordRequestDto);
      debugPrint('Reset password success repo impl');
    } catch (e) {
      throw Exception(
          'Reset password failed, please try again, ${e.toString()}');
    }
  }

  Future<String?> signInWithGoogle() async {
    // const GOOGLE_CLIENT_ID = "3547727424-dd830mm0li4cmi4q2kcr7ndorfpgi5rs.apps.googleusercontent.com";
    // try {
    //   GoogleSignIn googleSignIn;
    //   if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
    //     googleSignIn = GoogleSignIn(
    //       scopes: [
    //         'profile',
    //         'email',
    //         'openid',
    //       ],
    //     );
    //   } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    //     googleSignIn = GoogleSignIn(
    //       clientId: GOOGLE_CLIENT_ID,
    //       scopes: [
    //         'email',
    //         'profile',
    //         'openid',
    //       ],
    //     );
    //   } else {
    //     googleSignIn = GoogleSignIn();
    //   }
    //   final GoogleSignInAccount? account = await googleSignIn.signIn();
    //   debugPrint("account: $account");
    //   if (account == null) {
    //     return null;
    //   }
    //
    //   final GoogleSignInAuthentication googleAuth = await account.authentication;
    //
    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );
    //
    //   await FirebaseAuth.instance.signInWithCredential(credential);
    //
    //   debugPrint("ID Token: ${googleAuth.idToken}");
    //   debugPrint("User already signed in. ID Token: ${credential.idToken}");
    //
    //   return credential.idToken;
    // } catch (e) {
    //   throw Exception('Google sign in failed, please try again, ${e.toString()}');
    // }
    return null;
  }

  @override
  void updateAuthStatus(AuthenticationStatus status) {
    debugPrint('Manually updating auth status to: $status');
    _controller.add(status);
  }
}
