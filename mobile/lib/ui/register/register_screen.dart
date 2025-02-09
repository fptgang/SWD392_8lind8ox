import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:mobile/ui/register/widgets/register_form.dart';
import '../../blocs/register/register_bloc.dart';
import '../../main.dart';


class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => RegisterScreen());
  }

  final AuthRepository authRepository = GetIt.instance<AuthRepository>();
  @override
  Widget build(BuildContext context) {
    return  BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(authRepository: authRepository),
        child: Scaffold(
          backgroundColor: getColorSkin().backgroundColor,
          body: Center(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RegisterForm(),
                ),
              ),
            ),
          ),
        ),
      );
  }
}
