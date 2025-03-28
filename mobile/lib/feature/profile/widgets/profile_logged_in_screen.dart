import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/app/blocs/authentication/authentication_state.dart';
import 'package:mobile/app/di/injection.dart';
import 'package:mobile/base/theme/theme.dart';
import 'package:mobile/feature/profile/blocs/account/account_bloc.dart';
import 'package:mobile/feature/profile/blocs/account/account_event.dart';
import 'package:mobile/feature/profile/blocs/account/account_state.dart';
import 'package:mobile/feature/profile/widgets/setting/account_setting_section.dart';
import 'package:mobile/feature/profile/widgets/setting/profile_section.dart';
import 'package:mobile/feature/profile/widgets/setting/setting_tile_list.dart';

import '../../../utils/enum/enum.dart';

class ProfileLoggedInScreen extends StatelessWidget {
  const ProfileLoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountBloc = getIt<AccountBloc>();
    
    accountBloc.add(const LoadAccount());
    
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == AuthenticationStatus.unauthenticated) {
              context.push('/main/home');
            }
          },
        ),
        BlocListener<AccountBloc, AccountState>(
          bloc: accountBloc,
          listener: (context, state) {
            if (state is AccountError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error loading account: ${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: BlocProvider.value(
        value: accountBloc,
        child: Scaffold(
          backgroundColor: getColorSkin().backgroundColor,
          body: BlocBuilder<AccountBloc, AccountState>(
            bloc: accountBloc,
            builder: (context, state) {
              if (state is AccountLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileSection(),
                      const SizedBox(height: 20),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
