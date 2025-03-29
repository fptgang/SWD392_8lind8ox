import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/feature/auth/login/blocs/login_bloc.dart';
import 'package:mobile/feature/auth/login/blocs/login_event.dart';
import 'package:mobile/feature/auth/login/blocs/login_state.dart';

// Extensions for FormzSubmissionStatus
extension FormzSubmissionStatusX on FormzSubmissionStatus {
  bool get isSubmissionSuccess => this == FormzSubmissionStatus.success;
  bool get isSubmissionFailure => this == FormzSubmissionStatus.failure;
  bool get isSubmissionInProgress => this == FormzSubmissionStatus.inProgress;
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        } else if (state.status.isSubmissionSuccess) {
          context.go('/main');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(),
          const SizedBox(height: 16),
          _EmailInput(),
          const SizedBox(height: 8),
          _PasswordInput(),
          const SizedBox(height: 8),
          _ForgotPasswordButton(),
          const SizedBox(height: 16),
          _LoginButton(),
          const SizedBox(height: 8),
          _SignUpButton(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Image.network(
          'https://mir-s3-cdn-cf.behance.net/projects/404/b3273676004649.Y3JvcCw3NTYsNTkxLDU4MiwyMA.png',
          height: 200.h,
          width: 200.h,
        ),
        const Text(
          'Sign in to continue',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginEmailChanged(email)),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            helperText: '',
            errorText: state.email.isPure
                ? null
                : (state.email.isValid ? null : 'Invalid email'),
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            helperText: '',
            errorText: state.password.isPure
                ? null
                : (state.password.isValid
                    ? null
                    : 'Password must be at least 8 characters'),
            prefixIcon: const Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            key: const Key('loginForm_continue_raisedButton'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: state.isValid
                ? () => context.read<LoginBloc>().add(const LoginSubmitted())
                : null,
            child: state.status.isSubmissionInProgress
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Login'),
          ),
        );
      },
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        key: const Key('loginForm_forgotPassword_textButton'),
        onPressed: () => context.go('/forgot-password'),
        child: const Text('Forgot Password?'),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?"),
        TextButton(
          key: const Key('loginForm_createAccount_textButton'),
          onPressed: () => context.go('/sign-up'),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
