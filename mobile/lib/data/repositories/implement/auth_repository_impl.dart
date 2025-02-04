import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/mapper/auth_response_mapper.dart';
import 'package:mobile/data/mapper/jwt_response_mapper.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/auth_response_model.dart';
import 'package:mobile/data/models/jwt_response_model.dart';
import 'package:mobile/di/injection.dart';
import 'package:openapi/api.dart';
import '../../../enum/enum.dart';
import '../auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _controller = StreamController<AuthenticationStatus>();
  var box = Hive.box('authentication');

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  void dispose() => _controller.close();

  final DefaultApi _apiService = getIt<DefaultApi>();

  AuthRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<AccountModel> getCurrentUserInformation() {
    // TODO: implement getCurrentUserInformation
    throw UnimplementedError();
  }

  @override
  Future<AuthResponseModel> login(LoginRequestDto loginRequestDto) async {
    try {
      AuthResponseDto? dto = await _apiService.login(loginRequestDto);
      debugPrint("ddddddddddto: $dto");
      if (dto == null) {
        throw Exception('Login failed, please try again');
      }
      await Future.delayed(
        const Duration(milliseconds: 300),
        () => _controller.add(AuthenticationStatus.authenticated),
      );
      debugPrint("dto: $dto");
      debugPrint("AuthMapper.toModel(dto): ${AuthMapper.toModel(dto)}");
      debugPrint("${AuthenticationStatus.authenticated}");
      return AuthMapper.toModel(dto);
    } catch (e) {
      throw Exception(
          'Login failed repository, please try again, ${e.toString()}');
    }
  }

  @override
  Future<AuthResponseModel> loginWithGoogle(String token) async {
    try {
      AuthResponseDto? dto = await _apiService.loginWithGoogle(token);
      debugPrint("dto: $dto");
      debugPrint("token: $token");
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
      debugPrint('Logout success repo impl');
      // await Future.delayed(
      //   const Duration(milliseconds: 300),
      //       () => _controller.add(AuthenticationStatus.unauthenticated),
      // );
    } catch (e) {
      throw Exception('Logout failed, please try again, ${e.toString()}');
    }
  }

  @override
  Future<JwtResponseModel> refreshToken(String body) async {
    JwtResponseDto? dto = await _apiService.refreshToken(body);
    if (dto == null) {
      throw Exception('Session expired, please login again');
    }
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => _controller.add(AuthenticationStatus.authenticated),
    );
    return JwtMapper.toModel(dto);
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
    const GOOGLE_CLIENT_ID = "3547727424-dd830mm0li4cmi4q2kcr7ndorfpgi5rs.apps.googleusercontent.com";
    try {
      GoogleSignIn googleSignIn;
      if (kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
        googleSignIn = GoogleSignIn(
          scopes: [
            'profile',
            'email',
            'openid',
          ],
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        googleSignIn = GoogleSignIn(
          clientId: GOOGLE_CLIENT_ID,
          scopes: [
            'email',
            'profile',
            'openid',
          ],
        );
      } else {
        googleSignIn = GoogleSignIn();
      }
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      debugPrint("account: $account");
      if (account == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await account.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint("ID Token: ${googleAuth.idToken}");
      debugPrint("User already signed in. ID Token: ${credential.idToken}");

      return credential.idToken;
    } catch (e) {
      throw Exception('Google sign in failed, please try again, ${e.toString()}');
    }
  }

}
