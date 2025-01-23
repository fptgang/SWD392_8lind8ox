
import 'package:equatable/equatable.dart';
import 'package:mobile/data/models/account_model.dart';

import '../../enum/enum.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = AccountModel.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(AccountModel user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final AccountModel user;

  @override
  List<Object> get props => [status, user];
}