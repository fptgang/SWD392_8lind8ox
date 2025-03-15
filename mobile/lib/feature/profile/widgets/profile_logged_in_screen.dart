import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/app/blocs/authentication/authentication_state.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/profile/widgets/setting/account_setting_section.dart';
import 'package:mobile/feature/profile/widgets/setting/profile_section.dart';
import 'package:mobile/feature/profile/widgets/setting/setting_tile_list.dart';

import '../../../utils/enum/enum.dart';

class ProfileLoggedInScreen extends StatelessWidget {
  const ProfileLoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          context.push('/main/home');
        }
      },
      child: Scaffold(
        backgroundColor: getColorSkin().backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "General Settings",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              // Profile Section
              const ProfileSection(),
              const SizedBox(height: 20),

              // Account Settings Section
              const Text(
                "Account Settings",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),

              const AccountSettingsSection(),
              const SizedBox(height: 20),

              // Settings Tile List
              SettingsTileList(
                onLogout: () => context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutPressed()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
