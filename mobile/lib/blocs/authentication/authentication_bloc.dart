import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/repositories/auth_repository.dart';

import '../../data/repositories/account_repository.dart';
import '../../enum/enum.dart';
import 'authentication_state.dart';

part 'authentication_event.dart';

@injectable
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {

  @factoryMethod
  AuthenticationBloc({
    required AuthRepository authenticationRepository,
    required AccountRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
    on<AuthenticationLoggedIn>(_onLoggedIn);
  }

  final AuthRepository _authenticationRepository;
  final AccountRepository _userRepository;

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.status,
      onData: (status) async {
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            return emit(const AuthenticationState.unauthenticated());
          case AuthenticationStatus.authenticated:
            final user = await _tryGetUser();
            return emit(
              user != null
                  ? AuthenticationState.authenticated(user)
                  : const AuthenticationState.unauthenticated(),
            );
          case AuthenticationStatus.unknown:
            return emit(const AuthenticationState.unknown());
        }
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) {
    try{
      _authenticationRepository.logout();
      emit(const AuthenticationState.unauthenticated());
      debugPrint('Logout success');
    } catch (_) {
      emit(state);
      debugPrint('Logout failed');
    }
  }


  void _onLoggedIn(
      AuthenticationLoggedIn event,
      Emitter<AuthenticationState> emit,
      ) {
    try{
      emit(AuthenticationState.authenticated(AccountModel.empty));
      debugPrint('login success');
    } catch (_) {
      emit(state);
      debugPrint('login failed');
    }
  }

  Future<AccountModel?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }
}
  