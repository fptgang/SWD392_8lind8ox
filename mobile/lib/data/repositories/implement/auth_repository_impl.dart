import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/mapper/auth_response_mapper.dart';
import 'package:mobile/data/mapper/jwt_response_mapper.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/auth_response_model.dart';
import 'package:mobile/data/models/jwt_response_model.dart';
import 'package:openapi/api.dart';
import '../../../enum/enum.dart';
import '../auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  void dispose() => _controller.close();

  DefaultApi _apiService = DefaultApi();
  AuthRepository() {
    _apiService = DefaultApi();
  }

  @override
  Future<AccountModel> getCurrentUserInformation() {
    // TODO: implement getCurrentUserInformation
    throw UnimplementedError();
  }

  @override
  Future<AuthResponseModel> login(LoginRequestDto loginRequestDto) async {
    try{
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
    }
    catch(e){
      throw Exception('Login failed repository, please try again, ${e.toString()}');
    }

  }

  @override
  Future<AuthResponseModel> loginWithGoogle(String body) async{
    AuthResponseDto? dto = await _apiService.loginWithGoogle(body);
    if (dto == null) {
      throw Exception('Login failed, please try again');
    }
    await Future.delayed(
      const Duration(milliseconds: 300),
          () => _controller.add(AuthenticationStatus.authenticated),
    );
    return AuthMapper.toModel(dto);

  }

  @override
  void logout() async {
    _controller.add(AuthenticationStatus.unauthenticated);
    await _apiService.logout();
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
    await _apiService.register(registerRequestDto);
  }

  @override
  void forgotPassword(ForgotPasswordRequestDto forgotPasswordRequestDto) async {
    await _apiService.forgotPassword(forgotPasswordRequestDto);
  }

  @override
  void resetPassword(ResetPasswordRequestDto resetPasswordRequestDto) async{
    await _apiService.resetPassword(resetPasswordRequestDto);
  }


  @override
  Future<String?> signInWithGoogle() async {
    const GOOGLE_CLIENT_ID = "456982582712-hhilqsfqccnkfvrc8mnqkcf0klchmesm.apps.googleusercontent.com";

    try{
      const List<String> scopes = <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];
      GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: GOOGLE_CLIENT_ID,
        scopes: scopes,
      );
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      await googleSignIn.canAccessScopes(scopes);
      if (account == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      return googleAuth.idToken;
    }
    catch(e){
      throw Exception('Google sign in failed, please try again, ${e.toString()}');
    }
  }

  // Future<void> signOut() async {
  //   await _googleSignIn.signOut();
  // }
 
}