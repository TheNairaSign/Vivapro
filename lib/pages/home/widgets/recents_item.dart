import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/core/utils/get_time_ago.dart';

class RecentsItem extends StatelessWidget {
  const RecentsItem({super.key, required this.log});
  final ActivityLog log;

  @override
  Widget build(BuildContext context) {
    final name = log.favoriteContact?.contactDetails.displayName ?? log.contactName;
    final date = log.timestamp;
    final timeAgo = formatTimeAgo(date);

    IconData activityIcon;
    Color activityColor;
    String durationText = '';

    if (log.type == ActivityType.call) {
      if (log.durationSeconds == 0) {
        activityIcon = Icons.call_missed;
        activityColor = Colors.redAccent;
      } else {
        activityIcon = Ionicons.call_outline;
        activityColor = Colors.greenAccent;
        durationText = ' • ${_formatDuration(log.durationSeconds ?? 0)}';
      }
    } else {
      activityIcon = Ionicons.information_circle_outline;
      activityColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: activityColor.withValues(alpha: .25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              activityIcon,
              color: activityColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$timeAgo$durationText',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
          if (log.type == ActivityType.call && log.durationSeconds == 0)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D8CFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'Callback',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
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
