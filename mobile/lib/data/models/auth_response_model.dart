import 'package:mobile/data/models/account_model.dart';
import 'package:openapi/api.dart';


class AuthResponseModel {
  final String token;
  final String? refreshToken;
  String email;
  AccountModel accountModel;

  AuthResponseModel({
    required this.token,
    this.refreshToken,
    required this.email,
    required this.accountModel,
  });

  List<Object?> get props => [
    token,
    refreshToken,
    email,
    accountModel,
  ];
}
