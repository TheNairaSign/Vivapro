import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/call_log/data/call_log_model.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class ActivityItem extends StatelessWidget {
  final CallLogModel log;

  const ActivityItem({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final name = (log.name != null && log.name!.isNotEmpty)
        ? log.name!
        : (log.formattedNumber ?? 'Unknown');

    final date = DateTime.fromMillisecondsSinceEpoch(log.timestamp ?? 0);
    // 10:30 AM
    // Better time formatting
    final formattedTime = DateFormat('h:mm a').format(date);

    final isMissed = log.callType == CallType.missed;
    final isIncoming = log.callType == CallType.incoming;
    final isOutgoing = log.callType == CallType.outgoing;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Status config
    Color statusColor;
    String statusText;
    IconData? overlayIcon;
    Color overlayBgColor;
    Color overlayIconColor;

    if (isMissed) {
      statusColor = const Color(0xFFE67E22); // Orange
      statusText = 'Missed call'; // Or "Missed reminder" for similarity
      overlayIcon = Icons.priority_high;
      overlayBgColor = isDark ? const Color(0xFF422F0E) : const Color(0xFFFFF8E1); // Light yellow
      overlayIconColor = const Color(0xFFE67E22);
    } else if (isIncoming && log.duration! > 0) {
       statusColor = const Color(0xFF2D8CFF); // Blue
       statusText = 'Incoming • ${_formatDuration(log.duration ?? 0)}';
       overlayIcon = Icons.call_received;
       overlayBgColor = isDark ? const Color(0xFF132F4D) : const Color(0xFFE3F2FD);
       overlayIconColor = const Color(0xFF2D8CFF);
    } else if (isOutgoing) {
      statusColor = const Color(0xFF00C853); // Green
      statusText = 'Outgoing • ${_formatDuration(log.duration ?? 0)}';
      overlayIcon = Icons.arrow_outward;
      overlayBgColor = isDark ? const Color(0xFF10361A) : const Color(0xFFE8F5E9);
      overlayIconColor = const Color(0xFF00C853);
    } else {
      // Default
      statusColor = Colors.grey;
      statusText = log.callType.toString().split('.').last;
      overlayIcon = Icons.phone;
      overlayBgColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
      overlayIconColor = Colors.grey;
    }

    // Special case for design matching "Dad" example which has a "Call" button
    // We can simulate this if it's a missed call
    final showCallButton = isMissed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GlobalColors.containerColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with Overlay
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: isDark ? const Color(0xFF3E3E4A) : const Color(0xFFE0E0E0),
                backgroundImage: null, // TODO: Load actual image if available
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.grey[300] : Colors.grey,
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C3E) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2), // White border effect
                  child: Container(
                     decoration: BoxDecoration(
                      color: overlayBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      overlayIcon,
                      size: 12,
                      color: overlayIconColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Trailing Actions
          if (showCallButton)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C29) : const Color(0xFFFFF9E6), // Light yellow bg like Insight
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Call',
                style: TextStyle(
                  color: Color(0xFFE67E22), // Orange text
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            )
          else 
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    formattedTime,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    if (minutes < 60) {
      final remainingSeconds = seconds % 60;
      return remainingSeconds > 0 ? '${minutes}m ${remainingSeconds}s' : '${minutes}m';
    }
    return '${minutes}m';
  }
}
