

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/auth_response_model.dart';
import 'package:mobile/data/models/jwt_response_model.dart';
import 'package:openapi/api.dart';

import '../../enum/enum.dart';

@lazySingleton
@injectable
abstract class AuthRepository {
  Future<AccountModel> getCurrentUserInformation();
  Future<AuthResponseModel> login(LoginRequestDto loginRequestDto);
  Future<AuthResponseModel> loginWithGoogle(String token);
  Future<String?> signInWithGoogle();
  void register(RegisterRequestDto registerRequestDto);
  void forgotPassword(ForgotPasswordRequestDto forgotPasswordRequestDto);
  void resetPassword(ResetPasswordRequestDto resetPasswordRequestDto);
  void logout();
  Future<JwtResponseModel> refreshToken(String refreshToken);
  Stream<AuthenticationStatus> get status;
}