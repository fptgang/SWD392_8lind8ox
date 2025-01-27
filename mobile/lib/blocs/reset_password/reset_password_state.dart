

  import 'package:equatable/equatable.dart';
  import 'package:formz/formz.dart';
  import 'package:mobile/validation/username.dart';

  import '../../validation/password.dart';

  class ResetPasswordState extends Equatable{
    final FormzSubmissionStatus status;
    final EmailRegister email;
    final Password password;
    final Password confirmPassword;
    final String? token;
    final bool isValid;

    const ResetPasswordState({
      this.status = FormzSubmissionStatus.initial,
      this.email = const EmailRegister.pure(),
      this.password = const Password.pure(),
      this.confirmPassword = const Password.pure(),
      this.token = "",
      this.isValid = false,
    });

    ResetPasswordState copyWith({
      FormzSubmissionStatus? status,
      EmailRegister? email,
      Password? password,
      Password? confirmPassword,
      String? token,
      bool? isValid,
    }){
      return ResetPasswordState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        token: token ?? this.token,
        isValid: isValid ?? this.isValid,
      );
    }

    @override
    List<Object?> get props => [status, email, password, confirmPassword, token];
  }