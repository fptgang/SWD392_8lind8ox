// login_form.dart (updated version)
// Just the _LoginButton component, since that's where the main issue is
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:formz/formz.dart';
import 'package:mobile/feature/auth/login/blocs/login_bloc.dart';
import 'package:mobile/feature/auth/login/blocs/login_state.dart';

import '../../../../base/theme/theme.dart';
import '../blocs/login_event.dart';

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        // Show loading indicator if submission is in progress
        if (state.status.isInProgress) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
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
          onPressed: state.isValid
              ? () {
                  // Dismiss keyboard
                  FocusScope.of(context).unfocus();
                  // Submit login
                  context.read<LoginBloc>().add(const LoginSubmitted());
                }
              : null,
          child: Text(
            AppLocalizations.of(context)!.login,
            style:
                TextStyle(fontSize: 16, color: getColorSkin().backgroundColor),
          ),
        );
      },
    );
  }
}
