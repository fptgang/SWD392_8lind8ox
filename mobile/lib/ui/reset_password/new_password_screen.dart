import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:mobile/ui/reset_password/widgets/password_field.dart';
import 'package:mobile/ui/reset_password/widgets/password_strength.dart';

import '../../blocs/reset_password/reset_password_bloc.dart';
import '../../blocs/reset_password/reset_password_event.dart';
import '../../blocs/reset_password/reset_password_state.dart';


class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const NewPasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorSkin().backgroundColor,
      appBar: AppBar(
        backgroundColor: getColorSkin().backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: getColorSkin().backgroundColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: getColorSkin().backgroundColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Create a strong password for updating\nj*********0@gmail.com",
              style: TextStyle(
                fontSize: 16,
                color: getColorSkin().lightGrey300,
              ),
            ),
            SizedBox(height: 30.h),
            _PasswordFields(),
            const Spacer(),
            _SubmitButton(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isValid
                ? () => context
                .read<ResetPasswordBloc>()
                .add(RequestResetPassword())
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: getColorSkin().accentColor,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 18,
                color: getColorSkin().backgroundColor,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
          builder: (context, state) {
            return buildPasswordField(
              "New Password",
              state.password.value,
                  (value) =>
                  context
                      .read<ResetPasswordBloc>()
                      .add(PasswordChanged(value)),
              state.password.isValid,
            );
          },
        ),
        SizedBox(height: 8.h),
        buildPasswordStrength(),
        SizedBox(height: 16.h),
        BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
          builder: (context, state) {
            return buildPasswordField(
              "Confirm Password",
              state.confirmPassword.value,
                  (value) =>
                  context
                      .read<ResetPasswordBloc>()
                      .add(ConfirmPasswordChanged(value)),
              state.password.value == state.confirmPassword.value,
            );
          },
        ),
        BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
          builder: (context, state) {
            if (!state.isValid &&
                state.password.value != state.confirmPassword.value) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "The password confirmation doesn’t match.",
                  style: TextStyle(color: getColorSkin().red, fontSize: 14),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
