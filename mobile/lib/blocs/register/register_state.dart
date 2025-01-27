  import 'package:equatable/equatable.dart';
  import 'package:formz/formz.dart';

  import '../../validation/password.dart';
  import '../../validation/username.dart';

  class RegisterState extends Equatable {
    final EmailRegister email;
    final Password password;
    final String? confirmPassword;
    final String? firstName;
    final String? lastName;
    final FormzSubmissionStatus status;
    final bool isValid;

    const RegisterState({
      this.email = const EmailRegister.pure(),
      this.password = const Password.pure(),
      this.confirmPassword = '',
      this.firstName = '',
      this.lastName = '',
      this.status = FormzSubmissionStatus.initial,
      this.isValid = false,
    });

    RegisterState copyWith({
      EmailRegister? email,
      Password? password,
      String? confirmPassword,
      String? firstName,
      String? lastName,
      FormzSubmissionStatus? status,
      bool? isValid,
    }) {
      return RegisterState(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid,
      );
    }

    @override
    List<Object?> get props => [email, password, confirmPassword, firstName, lastName, status, isValid];
  }
