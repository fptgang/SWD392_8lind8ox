import 'package:openapi/api.dart';


class AuthResponseModel {
  final String? token;
  final String? refreshToken;
  String? email;
  AccountDto? accountResponseDTO;

  AuthResponseModel({
    this.token,
    this.refreshToken,
    this.email,
    this.accountResponseDTO,
  });

  String? get getToken => token;
}
