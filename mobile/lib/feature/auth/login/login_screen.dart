import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/auth/login/widget/login_form.dart';

import '../../../app/di/injection.dart';
import 'blocs/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building LoginScreen...');

    return BlocProvider<LoginBloc>(
      create: (context) => getIt<LoginBloc>(),
      child: Scaffold(
        backgroundColor: getColorSkin().backgroundColor,
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20), child: LoginForm()),
            ),
          ),
        ),
      ),
    );
  }
}
