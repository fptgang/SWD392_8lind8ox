

import 'package:bloc/bloc.dart';
import 'package:mobile/blocs/register/register_event.dart';
import 'package:mobile/blocs/register/register_state.dart';
import 'package:mobile/data/repositories/auth_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>{
  final AuthRepository _authRepository;


  RegisterBloc(this._authRepository) : super(RegisterState()){
    on<RegisterSubmitted>((onRegisterSubmitted));
  }

  void onRegisterSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit ) async{
  }

}