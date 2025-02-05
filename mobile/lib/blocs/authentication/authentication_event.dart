part of 'authentication_bloc.dart';

class AuthenticationEvent {
  const AuthenticationEvent();
}

 class AuthenticationSubscriptionRequested extends AuthenticationEvent {}

 class AuthenticationLogoutPressed extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final String token;

  AuthenticationLoggedIn({required this.token});
}
