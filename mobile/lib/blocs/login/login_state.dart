import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../validation/password.dart';
import '../../validation/username.dart';

class LoginState extends Equatable {
  const LoginState({
    this.token = "",
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
  });

  final String token;
  final FormzSubmissionStatus status;
  final Username username;
  final Password password;
  final bool isValid;

  LoginState copyWith({
    String? token,
    FormzSubmissionStatus? status,
    Username? username,
    Password? password,
    bool? isValid,
  }) {
    return LoginState(
      token: token ?? this.token,
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object> get props => [token, status, username, password];
}