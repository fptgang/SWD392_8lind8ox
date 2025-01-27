import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:mobile/blocs/reset_password/reset_password_bloc.dart';
import 'package:mobile/blocs/reset_password/reset_password_state.dart';
import '../../../blocs/reset_password/reset_password_event.dart';
import '../../core/theme/theme.dart';

class RequestResetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  RequestResetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Forgot Password",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: getColorSkin().backgroundColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Please enter your email account to send the link verification to reset your password.",
            style: TextStyle(
              fontSize: 16,
              color: getColorSkin().grey,
            ),
          ),
          SizedBox(height: 30.h),
          _EmailInput(emailController: emailController),
          Spacer(),
          _ForgotButton(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController emailController;

  const _EmailInput({required this.emailController});
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
          (ResetPasswordBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: getColorSkin().lightGrey700),
      key: const Key('forgotPasswordForm_usernameInput_textField'),
      decoration: InputDecoration(
        errorText: displayError != null ? 'invalid email' : null,
        hintText: "Email Address",
        hintStyle: TextStyle(color: getColorSkin().lightGrey700),
        prefixIcon: Icon(Icons.email_outlined, color: getColorSkin().lightGrey400),
        filled: true,
        fillColor: getColorSkin().backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: getColorSkin().lightGrey700, width: 2),
        ),
      ),
    );
  }
}

class _ForgotButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
          (ResetPasswordBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );

    if (isInProgressOrSuccess) return const CircularProgressIndicator();

    final isValid = context.select((ResetPasswordBloc bloc) => bloc.state.isValid);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('resetPasswordForm_continue_raisedButton'),
        style: ElevatedButton.styleFrom(
          backgroundColor: getColorSkin().accentColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isValid
            ? () => context.read<ResetPasswordBloc>().add(ForgotPassword())
            : null,
        child: Text(
          "Send Email",
          style: TextStyle(fontSize: 18, color: getColorSkin().backgroundColor),
        ),
      ),
    );
  }
}