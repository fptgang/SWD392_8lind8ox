import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/app/blocs/authentication/authentication_state.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/feature/profile/widgets/profile_logged_in_screen.dart';
import 'package:mobile/utils/enum/enum.dart';

import '../auth/register/blocs/register_bloc.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => ProfileScreen());
  }

  final AuthRepository authRepository = GetIt.instance<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorSkin().backgroundColor,
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: getColorSkin().white)),
        elevation: 0,
        backgroundColor: getColorSkin().primaryRed650,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.unauthenticated ||
              state.status == AuthenticationStatus.unknown) {
            return _buildLoginButton(context);
          }

          return BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(authRepository: authRepository),
            child: Center(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(4.w.h),
                  child: ProfileLoggedInScreen(),
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
