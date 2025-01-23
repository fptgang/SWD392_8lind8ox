

abstract class ResetPasswordEvent{
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];

}

class ForgotPasswordEvent extends ResetPasswordEvent{
  final bool isClickForgotPassword;

  const ForgotPasswordEvent(this.isClickForgotPassword);

  @override
  List<Object?> get props => [];
}

class RequestResetPasswordEvent extends ResetPasswordEvent{
  final String? email;
  const RequestResetPasswordEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class ResetPasswordResponseEvent extends ResetPasswordEvent{

}