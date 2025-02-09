import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import '../../../blocs/register/register_bloc.dart';
import '../../../blocs/register/register_event.dart';
import '../../../blocs/register/register_state.dart';
import '../../core/theme/theme.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.authenticationFailed)),
            );
        } else if (state.status.isSuccess){
          context.push('/login');
        }
      },
      child: Card(
        color: getColorSkin().backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                   AppLocalizations.of(context)!.register,
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    AppLocalizations.of(context)!.registerDescription,
                    style: TextStyle(color: getColorSkin().grey
                        , fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: _FirstnameInput(),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _LastnameInput(),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              _UsernameInput(),
              SizedBox(height: 20.h),

              _PasswordInput(),
              SizedBox(height: 20.h),
              _ConfirmPasswordInput(),
              SizedBox(height: 20.h),
              _RegisterButton(),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.orSignInWith,
                  style: TextStyle(color: getColorSkin().grey, fontSize: 16),
                ),
              ),
              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getColorSkin().backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: getColorSkin().lightGrey400),
                        ),
                      ),
                      icon: Icon(Icons.g_mobiledata, color: getColorSkin().black),
                      label: FittedBox(
                        child: Text(
                         AppLocalizations.of(context)!.loginWithGoogle,
                          style: TextStyle(color: getColorSkin().black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: TextButton(
                      onPressed: () {
                        // navigator.pushAndRemoveUntil<void>(
                        //   HomePageScreen.route(),
                        //       (route) => false,
                        // );
                        context.push('/main');
                      },
                      child: Text(
                        AppLocalizations.of(context)!.loginAsGuest,
                        style: TextStyle(fontSize: 16, color: getColorSkin().black),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.haveAccount,
                    style: TextStyle(
                      color: getColorSkin().grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    child: Text(
                      AppLocalizations.of(context)!.login,
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
          (RegisterBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      key: const Key('RegisterForm_usernameInput_textField'),
      onChanged: (email) {
        context.read<RegisterBloc>().add(RegisterEmailChanged(email));
      },
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: displayError != null ? AppLocalizations.of(context)!.invalidEmail : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
class _FirstnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
          (RegisterBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      key: const Key('RegisterForm_firstnameInput_textField'),
      onChanged: (email) {
        context.read<RegisterBloc>().add(RegisterFirstNameChanged(email));
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.firstName,
        errorText: displayError != null ? AppLocalizations.of(context)!.invalidFirstName : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
class _LastnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
          (RegisterBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      key: const Key('RegisterForm_lastnameInput_textField'),
      onChanged: (email) {
        context.read<RegisterBloc>().add(RegisterLastNameChanged(email));
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.lastName,
        errorText: displayError != null ? AppLocalizations.of(context)!.invalidLastName : null,
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
          (RegisterBloc bloc) => bloc.state.password.displayError,
    );

    return TextField(
      key: const Key('registerForm_passwordInput_textField'),
      onChanged: (password) {
        context.read<RegisterBloc>().add(RegisterPasswordChanged(password));
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.password,
        errorText: displayError != null ? AppLocalizations.of(context)!.invalidPassword : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: const Icon(Icons.visibility_off),
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
          (RegisterBloc bloc) => bloc.state.password.displayError,
    );

    return TextField(
      key: const Key('registerForm_confirmPasswordInput_textField'),
      onChanged: (password) {
        context.read<RegisterBloc>().add(RegisterConfirmPasswordChanged(password));
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.confirmPassword,
        errorText: displayError != null ? AppLocalizations.of(context)!.invalidPassword : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: const Icon(Icons.visibility_off),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
          (RegisterBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );

    if (isInProgressOrSuccess) return const CircularProgressIndicator();

    final isValid = context.select((RegisterBloc bloc) => bloc.state.isValid);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('registerForm_continue_raisedButton'),
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
            ? () => context.read<RegisterBloc>().add(RegisterSubmitted())
            : null,
        child: Text(
          AppLocalizations.of(context)!.register,
          style: TextStyle(fontSize: 16, color: getColorSkin().backgroundColor),
        ),
      ),
    );
  }
}