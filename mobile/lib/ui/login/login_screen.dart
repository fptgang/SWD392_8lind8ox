import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/ui/login/widget/login_form.dart';

import '../../blocs/login/login_bloc.dart';
import '../../di/injection.dart';
import '../core/theme/theme.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => LoginScreen());
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<LoginBloc>(
        create: (context) => getIt<LoginBloc>(),
        child: Scaffold(
          backgroundColor: getColorSkin().backgroundColor,
          body: Center(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: const LoginForm()
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}