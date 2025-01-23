abstract class LoginEvent {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginUsernameChanged extends LoginEvent {
  const LoginUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  final bool autoLogin;

  const LoginSubmitted(this.autoLogin);

  @override
  List<Object> get props => [autoLogin];
}

class LoginWithGoogle extends LoginEvent {}
