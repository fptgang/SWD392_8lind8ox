import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/ui/core/storage_keys_helper.dart';
import '../../data/repositories/account_repository.dart';
import '../../enum/enum.dart';
import 'authentication_state.dart';
part 'authentication_event.dart';

@injectable
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

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
        debugPrint('Auth status stream update: $status');
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            return emit(const AuthenticationState.unauthenticated());
          case AuthenticationStatus.authenticated:
            final user = await _userRepository.getUser();
            Hive.box('authentication').put('accountId', user.accountId);
            // StorageHelper.instance.write(SecureKey.USERID, user.accountId.toString());
            debugPrint('User account id: ${user.accountId} stored in authentication box');
            return emit(AuthenticationState.authenticated(user));
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

  Future<void> _onLoggedIn(
      AuthenticationLoggedIn event,
      Emitter<AuthenticationState> emit,
      ) async {
    try {
      _authenticationRepository.updateAuthStatus(AuthenticationStatus.authenticated);
      
      emit(AuthenticationState.authenticated(AccountModel()));
      debugPrint('login success, emitted authenticated state');
      final token = await Hive.box("authentication").get("loginToken");
      debugPrint('token: $token');
    } catch (e) {
      debugPrint('Login failed: $e');
      emit(state);
    }
  }
}
  