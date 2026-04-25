import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _buildSettingTile(
                context: context,
                icon: EvaIcons.bellOutline,
                iconColor: Colors.orange,
                title: 'Remind me to call',
                subtitle: 'Next: Sun 2:00 PM',
                hasSwitch: true,
                switchValue: true,
              ),
              Divider(
                height: 1,
                indent: 10,
                endIndent: 10,
                color: isDark ? Colors.grey[800] : Colors.grey[300],
              ),
              _buildSettingTile(
                context: context,
                icon: EvaIcons.pinOutline,
                iconColor: Colors.blue,
                title: 'Live Location',
                subtitle: 'Off',
                hasSwitch: true,
                switchValue: false,
              ),
              Divider(
                height: 1,
                indent: 10,
                endIndent: 10,
                color: isDark ? Colors.grey[800] : Colors.grey[300],
              ),
              _buildSettingTile(
                context: context,
                icon: EvaIcons.heartOutline,
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
    required BuildContext context,
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
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
              activeThumbColor: Theme.of(context).colorScheme.primary,
              activeTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              inactiveThumbColor: Theme.of(context).appBarTheme.backgroundColor,
              inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
              trackOutlineColor:  WidgetStateProperty.all(Colors.transparent),
            ),
          if (hasArrow) Icon(EvaIcons.arrowIosForwardOutline, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
