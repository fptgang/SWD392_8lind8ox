

abstract class ResetPasswordEvent{
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];

}

class ResetPasswordEmailChanged extends ResetPasswordEvent{
  const ResetPasswordEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends ResetPasswordEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends ResetPasswordEvent {
  final String confirmPassword;

  const ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}


class ForgotPassword extends ResetPasswordEvent{
  const ForgotPassword();
}


class RequestResetPassword extends ResetPasswordEvent{
  const RequestResetPassword();
}

class ResetPasswordResponse extends ResetPasswordEvent{
}