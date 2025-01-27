
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/blocs/reset_password/reset_password_bloc.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/reset_password/widgets/pin_code.dart';
import 'package:mobile/ui/reset_password/widgets/request_reset_password.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => ForgotPasswordScreen());
  }

  final AuthRepository authRepository = GetIt.instance<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorSkin().backgroundColor,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: getColorSkin().backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getColorSkin().brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider<ResetPasswordBloc>(
        create: (context) => ResetPasswordBloc(authRepository: authRepository),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RequestResetPasswordScreen(),
        ),
      ),
    );
  }
}
