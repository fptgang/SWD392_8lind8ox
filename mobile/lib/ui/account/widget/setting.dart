import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/blocs/authentication/authentication_bloc.dart';
import 'package:mobile/blocs/authentication/authentication_state.dart';
import 'package:mobile/ui/account/widget/menu_list_item.dart';

import '../../../enum/enum.dart';
import '../../core/theme/theme.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) =>
      previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          // Navigator.push(context, HomePageScreen.route());
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
          child:  Column(
            children: [
              // Profile Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      'https://placeholder.com/150x150',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'William John Malik',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Aggressive Investor',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Menu Items
              GestureDetector(
                onTap: () {
                  context.push('/profile-detail');
                },
                child: MenuListItem(
                  icon: Icons.person_outline,
                  title: 'Personal Data',
                  onTap: () {},
                ),
              ),
              MenuListItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {},
              ),
              MenuListItem(
                icon: Icons.description_outlined,
                title: 'E-Statement',
                onTap: () {},
              ),
              MenuListItem(
                icon: Icons.key_outlined,
                title: 'Referral Code',
                onTap: () {},
              ),
              MenuListItem(
                icon: Icons.help_outline,
                title: 'FAQs',
                onTap: () {},
              ),
              MenuListItem(
                icon: Icons.book_outlined,
                title: 'Our Handbook',
                onTap: () {},
              ),
              MenuListItem(
                icon: Icons.people_outline,
                title: 'Community',
                onTap: () {},
              ),

              const Spacer(),
              // Bottom Help Text
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.headset_mic_outlined,
                      color: Colors.blue,
                      size: 28,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Feel Free to Ask, We Ready to Help',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
