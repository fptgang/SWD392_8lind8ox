part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class AuthenticationSubscriptionRequested extends AuthenticationEvent {
  const AuthenticationSubscriptionRequested();
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.status);
  final AuthenticationStatus status;
}

class AuthenticationLogoutPressed extends AuthenticationEvent {
  const AuthenticationLogoutPressed();
}

class AuthenticationLoggedIn extends AuthenticationEvent {
  const AuthenticationLoggedIn();
}
