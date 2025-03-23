// login_bloc.dart (updated version)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/feature/auth/login/blocs/login_event.dart';
import 'package:mobile/feature/auth/login/blocs/login_state.dart';
import 'package:mobile/feature/auth/validation/username.dart';
import 'package:openapi/api.dart';

import '../../validation/password.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  @factoryMethod
  LoginBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginWithGoogle>(_onLoginWithGoogle);
  }

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([state.password, username]),
        status: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.username]),
        status: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    if (!state.isValid) {
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final loginRequestDto = LoginRequestDto(
        email: state.username.value,
        password: state.password.value,
      );

      final result = await _authRepository.login(loginRequestDto);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        token: result.token,
      ));
    } catch (error) {
      debugPrint("Login error: $error");
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onLoginWithGoogle(
      LoginWithGoogle event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      final String? token = await _authRepository.signInWithGoogle();

      if (token == null) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Google login failed',
        ));
        return;
      }

      final result = await _authRepository.loginWithGoogle(token);
      final box = Hive.box("authentication");
      await box.put("loginGoogleToken", result.token);

      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        token: result.token,
      ));
    } catch (error) {
      debugPrint("Google login error: $error");
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
