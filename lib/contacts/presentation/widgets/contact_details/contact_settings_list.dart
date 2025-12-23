import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class ContactSettingsList extends StatelessWidget {
  const ContactSettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings & Reminders',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: GlobalColors.containerColor(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: GlobalColors.boxShadow(context),
          ),
          child: Column(
            children: [
              _buildSettingTile(
                icon: Ionicons.notifications,
                iconColor: Colors.orange,
                title: 'Remind me to call',
                subtitle: 'Next: Sun 2:00 PM',
                hasSwitch: true,
                switchValue: true,
              ),
              Divider(
                height: 1,
                indent: 60,
                color: isDark ? Colors.grey[800] : Colors.grey[200],
              ),
              _buildSettingTile(
                icon: Ionicons.location,
                iconColor: Colors.blue,
                title: 'Live Location',
                subtitle: 'Off',
                hasSwitch: true,
                switchValue: false,
              ),
              Divider(
                height: 1,
                indent: 60,
                color: isDark ? Colors.grey[800] : Colors.grey[200],
              ),
              _buildSettingTile(
                icon: Ionicons.medical,
                iconColor: Colors.red,
                title: 'Emergency Bypass',
                subtitle: null,
                hasArrow: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    bool hasSwitch = false,
    bool switchValue = false,
    bool hasArrow = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasSwitch)
            Switch(
              value: switchValue,
              onChanged: (value) {},
              activeColor: Colors.lightBlue,
            ),
          if (hasArrow)
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
        ],
      ),
    );
  }
}
