import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/blocs/authentication/authentication_state.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/enum/enum.dart';
import 'package:mobile/ui/account/widget/account_detail.dart';
import 'package:mobile/ui/core/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../blocs/register/register_bloc.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => AccountScreen());
  }

  final AuthRepository authRepository = GetIt.instance<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorSkin().backgroundColor,
      appBar: AppBar(
        backgroundColor: getColorSkin().primaryRed650,
        elevation: 0,
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.unauthenticated ||
              state.status == AuthenticationStatus.unknown) {
            // User is not authenticated, show login button
            return _buildLoginButton(context);
          }

          return BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(authRepository: authRepository),
            child: Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AccountDetail(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.youAreNotLoggedIn,
            style: TextStyle(
              fontSize: 18,
              color: getColorSkin().textColor,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.push('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: getColorSkin().primaryRed650,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.login,
              style: TextStyle(
                fontSize: 16,
                color: getColorSkin().backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
