import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/models/contact/contact.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/core/extensions/capitalization.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/core/utils/get_time_ago.dart';

import 'package:vivapro/features/contacts/data/favorite_contact.dart';

class ContactHistorySection extends StatelessWidget {
  final Contact contact;
  final FavoriteContact? favorite;

  const ContactHistorySection({super.key, required this.contact, this.favorite});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent History',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<ActivityBloc, ActivityState>(
          builder: (context, state) {
            if (state is ActivityLoaded) {
              // Filter activities for this contact
              final contactActivities = state.activities
                .where((log) {
                  return log.contactId == contact.id;
                })
                .take(2)
                .toList();

              if (contactActivities.isEmpty) {
                return _buildEmptyHistory(context);
              }

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: contactActivities.asMap().entries.map((entry) {
                    final index = entry.key;
                    final log = entry.value;
                    return Column(
                      children: [
                        _buildHistoryItem(log),
                        if (index < contactActivities.length - 1)
                          Divider(
                            height: 1,
                            indent: 60,
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                          ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
            return _buildEmptyHistory(context);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyHistory(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(Ionicons.call_outline, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No recent activity',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(ActivityLog log) {
    final isCall = log.type == ActivityType.call;
    final isMissedCall = isCall && log.durationSeconds == 0;
    final isOutgoingCall = isCall && log.durationSeconds != null && log.durationSeconds! > 0;
    final date = log.timestamp;
    final timeAgo = formatTimeAgo(date);
    final duration = log.durationSeconds != null && log.durationSeconds! > 0
        ? _formatDuration(log.durationSeconds!)
        : '';

    String activityText;
    IconData activityIcon;
    Color activityColor;

    if (isCall) {
      if (isMissedCall) {
        activityText = 'Missed Call';
        activityIcon = Icons.call_missed;
        activityColor = Colors.red;
      } else if (isOutgoingCall) {
        activityText = 'Outgoing Call';
        activityIcon = Ionicons.arrow_up;
        activityColor = Colors.green;
      } else {
        activityText = 'Incoming Call';
        activityIcon = Ionicons.arrow_down;
        activityColor = Colors.green;
      }
    } else {
      activityText = log.type.name.capitalizeFirstofEach;
      activityIcon = Ionicons.information_circle_outline;
      activityColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activityColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              activityIcon,
              color: activityColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activityText,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '$timeAgo${duration.isNotEmpty ? ' • $duration' : ''}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }
}
