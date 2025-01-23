import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/login/login_event.dart';
import 'package:mobile/blocs/login/login_state.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginState()) {
    on<LoginSubmitted>((onLoginSubmitted));
    // on<LoginWithGoogle>((onLoginWithGoogle));
  }

  void onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    try {
      final result = await authRepository.login(state.email!, state.password!);
      if (result != null) {
        final box = Hive.box("authentication");
        await box.put("loginToken", result.getToken);
        emit(state.copyWith(status: "Login success"));
      } else {
        emit(state.copyWith(status: "Invalid email or password"));
      }
    } catch (error) {
      emit(state.copyWith(status: "Invalid email or password"));
    }
  }

  // void get onLoginWithGoogle;
}
