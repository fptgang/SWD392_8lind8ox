
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mobile/main.dart';
import 'package:mobile/ui/homepage/widget/homepage_screen.dart';
import 'package:mobile/ui/register/register_screen.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/login/login_bloc.dart';
import '../../../blocs/login/login_event.dart';
import '../../../blocs/login/login_state.dart';
import '../../core/theme/theme.dart';
import '../../reset_password/forgot_password_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        } else if (state.status.isSuccess){
          navigator.pushReplacement(HomePageScreen.route());
        }
      },
      child: Card(
        color: getColorSkin().backgroundColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: getColorSkin().textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Fill out the information below in order to access your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: getColorSkin().grey,
                ),
              ),

              const SizedBox(height: 24),
              _UsernameInput(),
              const SizedBox(height: 16),
              _PasswordInput(),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: getColorSkin().textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _LoginButton(),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children:  [
                  Expanded(
                    child: Divider(
                      color: getColorSkin().grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Or sign in with',
                      style: TextStyle(color: getColorSkin().grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: getColorSkin().grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<LoginBloc>().add(LoginWithGoogle());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getColorSkin().backgroundColor,
                      side: BorderSide(color: getColorSkin().grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    icon: Icon(Icons.g_mobiledata,
                        color: getColorSkin().black, size: 35,),
                    label: Text(
                      'Continue with Google',
                      style: TextStyle(color: getColorSkin().black),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(
                      color: getColorSkin().grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      navigator.pushReplacement(RegisterScreen.route());
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: getColorSkin().textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
          (LoginBloc bloc) => bloc.state.username.displayError,
    );

    return TextField(
      key: const Key('loginForm_usernameInput_textField'),
      onChanged: (username) {
        context.read<LoginBloc>().add(LoginUsernameChanged(username));
      },
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: displayError != null ? 'invalid email' : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
          (LoginBloc bloc) => bloc.state.password.displayError,
    );

    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (password) {
        context.read<LoginBloc>().add(LoginPasswordChanged(password));
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: displayError != null ? 'Invalid password' : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: const Icon(Icons.visibility_off),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
          (LoginBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );

    if (isInProgressOrSuccess) return const CircularProgressIndicator();

    final isValid = context.select((LoginBloc bloc) => bloc.state.isValid);
    debugPrint('isValid: $isValid');

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, loginState) {
        if (loginState.status == FormzSubmissionStatus.success) {
          final token = Hive.box("authentication").get("loginToken");
          context.read<AuthenticationBloc>().add(
            AuthenticationLoggedIn(token: token),
          );
        }
      },
      child: ElevatedButton(
        key: const Key('loginForm_continue_raisedButton'),
        style: ElevatedButton.styleFrom(
          backgroundColor: getColorSkin().accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
        onPressed: isValid
            ? () => context.read<LoginBloc>().add(LoginSubmitted())
            : null,
        child: Text(
          'Sign In',
          style: TextStyle(fontSize: 16, color: getColorSkin().backgroundColor),
        ),
      ),
    );
  }
}
