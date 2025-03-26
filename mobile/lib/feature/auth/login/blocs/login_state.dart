import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:mobile/feature/auth/validation/username.dart';

import '../../validation/password.dart';

class LoginState extends Equatable {
  final EmailRegister email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;

  const LoginState({
    this.email = const EmailRegister.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
  });

  LoginState copyWith({
    EmailRegister? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [email, password, status, isValid];
}
