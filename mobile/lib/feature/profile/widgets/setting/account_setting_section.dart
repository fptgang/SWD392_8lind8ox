import 'package:flutter/material.dart';
import 'package:mobile/base/theme/theme.dart';

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getColorSkin().backgroundColor,
      child: Column(
        children: [
          _buildSettingItem(
            title: "Push Notifications",
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: getColorSkin().primaryRed650,
            ),
          ),

          // Dark Mode Switch
          _buildSettingItem(
            title: "Dark Mode",
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: getColorSkin().primaryRed650,
            ),
          ),

          // Address Settings
          _buildSettingItem(
            title: "Address Settings",
            trailing: null,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
