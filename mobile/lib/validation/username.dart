import 'package:formz/formz.dart';

enum UsernameValidationError { empty }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    return null;
  }
}

enum EmailRegisterValidationError { empty }

class EmailRegister extends FormzInput<String, EmailRegisterValidationError> {
  const EmailRegister.pure() : super.pure('');
  const EmailRegister.dirty([super.value = '']) : super.dirty();

  @override
  EmailRegisterValidationError? validator(String value) {
    if (value.isEmpty) return EmailRegisterValidationError.empty;
    return null;
  }
}


