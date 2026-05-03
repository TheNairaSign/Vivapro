import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/core/extensions/capitalization.dart';
import 'package:vivapro/core/utils/get_time_ago.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';

class ActivityLogItem extends StatelessWidget {
  final ActivityLog log;
  final bool showChevron;

  const ActivityLogItem({
    super.key,
    required this.log,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final isCall = log.type == ActivityType.call;
    final isMissedCall = isCall && (log.durationSeconds == 0 || log.durationSeconds == null) && !log.isIncoming;
    final isOutgoingCall = isCall && !log.isIncoming && log.durationSeconds != null && log.durationSeconds! > 0;
    final isIncomingCall = isCall && log.isIncoming;
    
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
      } else if (isIncomingCall) {
        activityText = 'Incoming Call';
        activityIcon = Ionicons.arrow_down;
        activityColor = Colors.green;
      } else {
        activityText = 'Call';
        activityIcon = Ionicons.call_outline;
        activityColor = Colors.blue;
      }
    } else if (log.type == ActivityType.message) {
      activityText = log.isIncoming ? 'Incoming Message' : 'Outgoing Message';
      activityIcon = Ionicons.chatbubble_ellipses_outline;
      activityColor = Colors.blue;
    } else {
      activityText = log.type.name.capitalizeFirstofEach;
      activityIcon = Ionicons.information_circle_outline;
      activityColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: activityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              activityIcon,
              color: activityColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activityText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$timeAgo${duration.isNotEmpty ? ' • $duration' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          if (showChevron) Icon(Icons.chevron_right, color: Colors.grey[400], size: 18),
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
