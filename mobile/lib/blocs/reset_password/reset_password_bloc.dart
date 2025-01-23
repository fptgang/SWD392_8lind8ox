

import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/reset_password/reset_password_event.dart';
import 'package:mobile/blocs/reset_password/reset_password_state.dart';
import 'package:mobile/data/repositories/auth_repository.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState>{
  final AuthRepository _authRepository;

  ResetPasswordBloc(this._authRepository) : super(ResetPasswordState()){
    on<ForgotPasswordEvent>((onForgotPassword));
    on<RequestResetPasswordEvent>((onRequestResetPassword));
    on<ResetPasswordResponseEvent>((onResetPasswordResponse));
  }

  void onForgotPassword(ForgotPasswordEvent, Emitter<ResetPasswordState> emit) async{

  }

  void onRequestResetPassword(RequestResetPasswordEvent, Emitter<ResetPasswordState> emit) async{

  }

  void onResetPasswordResponse(ResetPasswordResponseEvent, Emitter<ResetPasswordState> emit) async{

  }

}