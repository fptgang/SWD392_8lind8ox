import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/ui/core/theme/theme.dart';

class SettingsTileList extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsTileList({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getColorSkin().backgroundColor,
      child: Column(
        children: [
          _buildSettingTile(
            context,
            icon: Icons.shopping_bag_outlined,
            title: "My Orders",
            onTap: () => context.push('/orders-history'),
          ),
          _buildSettingTile(
            context,
            icon: Icons.credit_card_outlined,
            title: "Manage Subscription",
            onTap: () {},
          ),
          _buildSettingTile(
            context,
            icon: Icons.shield_outlined,
            title: "Security",
            onTap: () {},
          ),
          _buildSettingTile(
            context,
            icon: Icons.card_giftcard_outlined,
            title: "Redeem a code",
            onTap: () {},
          ),
          _buildSettingTile(
            context,
            icon: Icons.headset_mic_outlined,
            title: "Contact us",
            onTap: () {},
          ),
          _buildSettingTile(
            context,
            icon: Icons.logout_outlined,
            title: "Log out",
            onTap: onLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}