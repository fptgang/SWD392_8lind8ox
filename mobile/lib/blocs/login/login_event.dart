

abstract class LoginEvent{
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final bool autoLogin;

  const LoginSubmitted(this.autoLogin);
  @override
  List<Object> get props => [autoLogin];
}

class LoginWithGoogle extends LoginEvent {}
