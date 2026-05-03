import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contact/contact.dart';
import 'package:vivapro/core/services/relationship_state_engine.dart';
import 'package:vivapro/core/utils/format_date.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/pages/add_favorite_page.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';

class ContactSettingsList extends StatelessWidget {
  final Contact contact;
  final FavoriteContact? favorite;
  final List<ScheduleCall> scheduledCalls;

  const ContactSettingsList({
    super.key,
    required this.contact,
    this.favorite,
    this.scheduledCalls = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final now = DateTime.now();

    // 1. Find manual upcoming calls
    final contactSchedules = scheduledCalls.where((c) {
      return c.contact.id == contact.id || (contact.id != null && c.id == contact.id);
    }).toList();

    final upcomingManualCalls = contactSchedules
        .where((c) => c.fullDateTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.fullDateTime.compareTo(b.fullDateTime));

    // 2. Get frequency-based next call date if favorite
    DateTime? frequencyNextDate;
    if (favorite != null) {
      frequencyNextDate = RelationshipStateEngine.getNextCallDate(favorite!);
    }

    // 3. Determine display text
    String nextCallSubtitle;
    bool isReminderActive = false;

    if (upcomingManualCalls.isNotEmpty) {
      final nextManual = upcomingManualCalls.first;
      nextCallSubtitle = 'Next: ${DateFunctions.formatDay(nextManual.date, now)} ${DateFunctions.formatTime(nextManual.time)}';
      isReminderActive = true;
    } else if (frequencyNextDate != null) {
      final state = RelationshipStateEngine.calculateState(favorite!);
      if (state == RelationshipState.overdue || state == RelationshipState.neverContacted) {
        nextCallSubtitle = 'Next: Today';
      } else {
        nextCallSubtitle = 'Next: ${DateFunctions.formatDay(frequencyNextDate, now)}';
      }
      isReminderActive = state != RelationshipState.onTrack;
    } else {
      nextCallSubtitle = 'No calls scheduled';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings & Reminders',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _buildSettingTile(
                context: context,
                icon: EvaIcons.bellOutline,
                iconColor: Colors.orange,
                title: 'Remind me to call',
                subtitle: nextCallSubtitle,
                hasSwitch: true,
                switchValue: isReminderActive,
              ),
              if (favorite != null) ...[
                _buildDivider(isDark),
                _buildSettingTile(
                  context: context,
                  icon: EvaIcons.clockOutline,
                  iconColor: Colors.blue,
                  title: 'Call Frequency',
                  subtitle: favorite!.callFrequency.name[0].toUpperCase() +
                      favorite!.callFrequency.name.substring(1),
                  hasArrow: true,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddFavoritePage(
                          contact: contact,
                          favoriteContact: favorite,
                          initialScrollSection: FavoriteScrollSection.frequency,
                        ),
                      ),
                    );
                  },
                ),
                _buildDivider(isDark),
                _buildSettingTile(
                  context: context,
                  icon: EvaIcons.flashOutline,
                  iconColor: Colors.purple,
                  title: 'Priority Level',
                  subtitle: favorite!.priority.name[0].toUpperCase() +
                      favorite!.priority.name.substring(1),
                  hasArrow: true,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddFavoritePage(
                          contact: contact,
                          favoriteContact: favorite,
                          initialScrollSection: FavoriteScrollSection.priority,
                        ),
                      ),
                    );
                  },
                ),
              ],
              _buildDivider(isDark),
              // _buildSettingTile(
              //   context: context,
              //   icon: EvaIcons.pinOutline,
              //   iconColor: Colors.teal,
              //   title: 'Live Location',
              //   subtitle: 'Off',
              //   hasSwitch: true,
              //   switchValue: false,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 60,
      endIndent: 16,
      color: isDark ? Colors.grey[800] : Colors.grey[200],
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ],
            ),
          ),
          if (hasSwitch)
            Switch(
              value: switchValue,
              onChanged: (value) {},
              activeThumbColor: Colors.white,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey[300],
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          if (hasArrow)
            Icon(EvaIcons.arrowIosForwardOutline,
                color: Colors.grey[400], size: 18),
        ],
      ),
      )
    );
  }
}
