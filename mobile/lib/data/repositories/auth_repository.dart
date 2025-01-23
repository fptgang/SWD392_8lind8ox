

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/auth_response_model.dart';
import 'package:mobile/data/models/jwt_response_model.dart';

import '../../enum/enum.dart';

@lazySingleton
@injectable
abstract class AuthRepository {
  Future<AccountModel> getCurrentUserInformation();
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> loginWithGoogle(String token);
  void register(String email, String password, String confirmPassword, String firstName, String lastName);
  void forgotPassword(String email);
  void resetPassword(String token, String password, String confirmPassword);
  void logout();
  Future<JwtResponseModel> refreshToken(String refreshToken);
  Stream<AuthenticationStatus> get status;
}