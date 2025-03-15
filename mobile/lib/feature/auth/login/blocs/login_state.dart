// login_state.dart (updated version)
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:mobile/feature/auth/validation/password.dart';
import 'package:mobile/feature/auth/validation/username.dart';

class LoginState extends Equatable {
  const LoginState({
    this.token = "",
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.errorMessage,
  });

  final String token;
  final FormzSubmissionStatus status;
  final Username username;
  final Password password;
  final bool isValid;
  final String? errorMessage;

  LoginState copyWith({
    String? token,
    FormzSubmissionStatus? status,
    Username? username,
    Password? password,
    bool? isValid,
    String? errorMessage,
  }) {
    return LoginState(
      token: token ?? this.token,
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [token, status, username, password, isValid, errorMessage];
}
