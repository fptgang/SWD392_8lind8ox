import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/blocs/login/login_event.dart';
import 'package:mobile/blocs/login/login_state.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:openapi/api.dart';

import '../../validation/password.dart';
import '../../validation/username.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  @factoryMethod
  LoginBloc({required AuthRepository authRepository})  : _authRepository = authRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(onLoginSubmitted);
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
      ),
    );
  }

  void onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    try {
      debugPrint("username: ${state.username.value}");
      final loginRequestDto = LoginRequestDto(
        email:state.username.value,
        password: state.password.value,
      );
      debugPrint("loginRequestDto: $loginRequestDto");
      final result = await _authRepository.login(loginRequestDto);
      debugPrint("result: $result");
        final box = Hive.box("authentication");
        await box.put("loginToken", result.getToken);
        debugPrint("loginToken: ${result.getToken}");
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      debugPrint("Error in onLoginSubmitted: $error");
      debugPrint("StackTrace: $stackTrace");
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void _onLoginWithGoogle(LoginWithGoogle event, Emitter<LoginState> emit) async {
    try {
      final String? token = await _authRepository.signInWithGoogle();
      debugPrint("toke11n: $token");
      if (token == null) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
        return;
      }
      debugPrint("token: $token");
      final result = await _authRepository.loginWithGoogle(token);
      final box = Hive.box("authentication");
      await box.put("loginToken", result.getToken);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error) {
      print(error);
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
