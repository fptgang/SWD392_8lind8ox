import 'dart:async';

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
  void forgotPassword(String email) {
    // TODO: implement forgotPassword
  }

  @override
  Future<AccountModel> getCurrentUserInformation() {
    // TODO: implement getCurrentUserInformation
    throw UnimplementedError();
  }

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
          () => _controller.add(AuthenticationStatus.authenticated),
    );
    throw UnimplementedError();
  }

  @override
  Future<AuthResponseModel> loginWithGoogle(String token) {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }

  @override
  void logout() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  @override
  Future<JwtResponseModel> refreshToken(String refreshToken) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  void register(String email, String password, String confirmPassword, String firstName, String lastName) {
    // TODO: implement register
  }

  @override
  void resetPassword(String token, String password, String confirmPassword) {
    // TODO: implement resetPassword
  }

 
}