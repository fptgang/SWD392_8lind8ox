import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:mobile/blocs/register/register_event.dart';
import 'package:mobile/blocs/register/register_state.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:openapi/api.dart';

import '../../validation/password.dart';
import '../../validation/username.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const RegisterState()) {
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterFirstNameChanged>(_onFirstNameChanged);
    on<RegisterLastNameChanged>(_onLastNameChanged);
    on<RegisterSubmitted>(onRegisterSubmitted);
  }

void _onEmailChanged(
  RegisterEmailChanged event,
  Emitter<RegisterState> emit,
) {
  final email = EmailRegister.dirty(event.email);
  emit(
    state.copyWith(
      email: email,
      isValid: Formz.validate([state.password, email]),
    ),
  );
}
  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email]),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    // final password = Password.dirty(event.confirmPassword);
    debugPrint('ConfirmPasswordChanged event: ${event.confirmPassword}');
    debugPrint('ConfirmPasswordChanged satte: ${state.confirmPassword}');
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        isValid: state.password.value == event.confirmPassword
      ),
    );
  }

  void _onFirstNameChanged(
      RegisterFirstNameChanged event,
      Emitter<RegisterState> emit,
      ) {
    emit(
      state.copyWith(
        firstName: event.firstName,
        isValid: event.firstName.isNotEmpty && event.firstName.length > 2,
      ),
    );
  }

  void _onLastNameChanged(
      RegisterLastNameChanged event,
      Emitter<RegisterState> emit,
      ) {
    emit(
      state.copyWith(
        lastName: event.lastName,
        isValid: event.lastName.isNotEmpty && event.lastName.length > 2,
      ),
    );
  }


  void onRegisterSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) async {
    try{
      final registerRequestDto = RegisterRequestDto(
        email: state.email.value,
        password: state.password.value,
        confirmPassword: state.confirmPassword,
        firstName: state.firstName,
        lastName: state.lastName
      );
      debugPrint('RegisterSubmittedww: ${state.confirmPassword}');
      debugPrint('RegisterSubmitted: $registerRequestDto');
      _authRepository.register(registerRequestDto);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
