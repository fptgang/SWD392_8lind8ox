

  import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
  import 'package:formz/formz.dart';
  import 'package:mobile/blocs/reset_password/reset_password_event.dart';
  import 'package:mobile/blocs/reset_password/reset_password_state.dart';
  import 'package:mobile/data/repositories/auth_repository.dart';
  import 'package:openapi/api.dart';

import '../../validation/password.dart';
import '../../validation/username.dart';

  class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState>{
    final AuthRepository _authRepository;

    ResetPasswordBloc({required AuthRepository authRepository}) : _authRepository = authRepository, super(ResetPasswordState()){
      on<ResetPasswordEmailChanged>((_onEmailChanged));
      on<PasswordChanged>((_onPasswordChanged));
      on<ConfirmPasswordChanged>((_onConfirmPasswordChanged));
      on<ForgotPassword>((_onForgotPassword));
      on<RequestResetPassword>((_onRequestResetPassword));
      on<ResetPasswordResponse>((_onResetPasswordResponse));
    }

    void _onEmailChanged(ResetPasswordEmailChanged event, Emitter<ResetPasswordState> emit) {
      final email = EmailRegister.dirty(event.email);
      emit(
        state.copyWith(
          email: email,
          isValid: Formz.validate([email]),
        ),
      );

      debugPrint('Updated email: ${email.value}');
    }


    void _onPasswordChanged(PasswordChanged event, Emitter<ResetPasswordState> emit) {
      final password = Password.dirty(event.password);
      emit(state.copyWith(
        password: password,
        isValid: password.isValid && (password.value == state.confirmPassword.value),
      ));
    }

    void _onConfirmPasswordChanged(ConfirmPasswordChanged event, Emitter<ResetPasswordState> emit) {
      final confirmPassword = Password.dirty(event.confirmPassword);
      emit(state.copyWith(
        confirmPassword: confirmPassword,
        isValid: confirmPassword.value == state.password.value && state.password.isValid,
      ));
    }


    void _onForgotPassword(ForgotPassword event, Emitter<ResetPasswordState> emit) async{
      final email = state.email.value;
      try{
        debugPrint('on Forgot password');
        final ForgotPasswordRequestDto forgotPasswordRequestDto = ForgotPasswordRequestDto(email: email);
        _authRepository.forgotPassword(forgotPasswordRequestDto);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
        debugPrint('Forgot password success $forgotPasswordRequestDto');
      }
      catch(error){
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }

    void _onRequestResetPassword(RequestResetPassword event, Emitter<ResetPasswordState> emit) async {
      try {
        debugPrint('on Request Reset Password');
        final ResetPasswordRequestDto resetPasswordRequestDto = ResetPasswordRequestDto(
            token: state.token,
            newPassword: state.password.value,
            confirmPassword: state.confirmPassword.value);
        _authRepository.resetPassword(resetPasswordRequestDto);
        emit(state.copyWith(status: FormzSubmissionStatus.success));
        debugPrint('Reset password success $resetPasswordRequestDto');
      }
      catch (error) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
        debugPrint('Reset password failed');
      }
    }

    void _onResetPasswordResponse(ResetPasswordResponse event, Emitter<ResetPasswordState> emit) {
      emit(state.copyWith(token: event.token));
      debugPrint('Token received: ${event.token}');
    }


  }