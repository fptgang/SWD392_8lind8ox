import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/blocs/authentication/authentication_state.dart';
import '../../../enum/enum.dart';
import '../../core/theme/theme.dart';
import '../../homepage/widget/homepage_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountDetail extends StatelessWidget {
  const AccountDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) =>
      previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          Navigator.push(context, HomePageScreen.route());
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
              _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = context.select((AuthenticationBloc bloc) => bloc.state.status);

    final isAuthenticated = authState == AuthenticationStatus.authenticated;

    return isAuthenticated
        ? SizedBox(
      width: double.infinity,
      child: ElevatedButton(
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
        onPressed: () => context.read<AuthenticationBloc>().add(AuthenticationLogoutPressed()),
        child: Text(
          AppLocalizations.of(context)!.logout,
          style: TextStyle(fontSize: 16, color: getColorSkin().backgroundColor),
        ),
      ),
    )
        : const SizedBox();
  }
}
