import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/blocs/authentication/authentication_state.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/repositories/account_repository.dart';
import 'package:mobile/data/repositories/auth_repository.dart';

import '../../../utils/enum/enum.dart';

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
    on<AuthenticationStatusChanged>(_onStatusChanged);

    // Listen to auth repository status stream
    _authStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final AuthRepository _authenticationRepository;
  final AccountRepository _userRepository;
  late final StreamSubscription<AuthenticationStatus> _authStatusSubscription;

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    debugPrint('Authentication subscription requested');

    // Check if tokens exist in storage
    final box = Hive.box('authentication');
    final token = box.get('loginToken');

    if (token == null || token.toString().isEmpty) {
      debugPrint('No authentication token found, logging out');
      emit(const AuthenticationState.unauthenticated());
      return;
    }

    try {
      debugPrint('Validating stored authentication token');
      // Check if token is valid by fetching user data
      final user = await _userRepository.getUser();
      debugPrint('Token validated, user authenticated: ${user.email}');
      emit(AuthenticationState.authenticated(user));
    } catch (e) {
      debugPrint('Token validation failed: $e');
      // Clear invalid tokens
      await box.delete('loginToken');
      await box.delete('refreshToken');
      emit(const AuthenticationState.unauthenticated());
    }
  }

  Future<void> _onStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    debugPrint('Auth status changed: ${event.status}');

    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        try {
          final user = await _userRepository.getUser();
          Hive.box('authentication').put('accountId', user.accountId);
          debugPrint('User authenticated: ${user.email}');
          return emit(AuthenticationState.authenticated(user));
        } catch (e) {
          debugPrint('Error getting user data: $e');
          return emit(const AuthenticationState.unauthenticated());
        }
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) {
    try {
      debugPrint('Logout requested');
      _authenticationRepository.logout();
      emit(const AuthenticationState.unauthenticated());
      debugPrint('Logout success');
    } catch (e) {
      debugPrint('Logout failed: $e');
      // Even if server logout fails, clear tokens and set state to unauthenticated
      final box = Hive.box('authentication');
      box.delete('loginToken');
      box.delete('refreshToken');
      emit(const AuthenticationState.unauthenticated());
    }
  }

  Future<void> _onLoggedIn(
    AuthenticationLoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      debugPrint('Login successful event received');
      _authenticationRepository
          .updateAuthStatus(AuthenticationStatus.authenticated);

      final user = await _userRepository.getUser();
      emit(AuthenticationState.authenticated(user));
      debugPrint('Login success, authenticated with user: ${user.email}');
    } catch (e) {
      debugPrint('Error processing login: $e');
      // If fetching user fails after login, try again or logout
      try {
        final token = Hive.box("authentication").get("loginToken");
        if (token == null || token.toString().isEmpty) {
          debugPrint('No valid token after login, logging out');
          _authenticationRepository
              .updateAuthStatus(AuthenticationStatus.unauthenticated);
          emit(const AuthenticationState.unauthenticated());
        } else {
          // Just authenticated with default account model
          emit(AuthenticationState.authenticated(AccountModel()));
        }
      } catch (e) {
        debugPrint('Error handling login failure: $e');
        emit(const AuthenticationState.unauthenticated());
      }
    }
  }
}
