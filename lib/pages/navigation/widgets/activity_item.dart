import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/core/extensions/capitalization.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_avatar.dart';
import 'package:vivapro/widgets/text_avatar.dart';

class ActivityItem extends StatefulWidget {
  final ActivityLog log;

  const ActivityItem({super.key, required this.log});

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final date = widget.log.timestamp;

    final formattedTime = DateFormat('h:mm a').format(date);

    final isMissed = widget.log.type == ActivityType.call && widget.log.durationSeconds == 0;
    final isIncoming = widget.log.type == ActivityType.call && (widget.log.durationSeconds ?? 0) > 0;
    final isOutgoing = widget.log.type == ActivityType.call && (widget.log.durationSeconds ?? 0) > 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Status config
    Color statusColor;
    String statusText;
    IconData? overlayIcon;
    Color overlayBgColor;
    Color overlayIconColor;

    if (isMissed) {
      statusColor = isDark ? Colors.red : const Color(0xFFE67E22); // Orange
      statusText = 'Missed call'; // Or "Missed reminder" for similarity
      overlayIcon = Icons.priority_high;
      overlayBgColor = isDark ? Colors.red.withAlpha(51) : const Color(0xFFFFF8E1); // Light yellow
      overlayIconColor = isDark ? Colors.red : const Color(0xFFE67E22);
    } else if (isIncoming) {
      statusColor = const Color(0xFF2D8CFF); // Blue
      statusText = 'Incoming • ${_formatDuration(widget.log.durationSeconds ?? 0)}';
      overlayIcon = Icons.call_received;
      overlayBgColor = isDark ? const Color(0xFF132F4D) : const Color(0xFFE3F2FD);
      overlayIconColor = const Color(0xFF2D8CFF);
    } else if (isOutgoing) {
      statusColor = const Color(0xFF00C853); // Green
      statusText = 'Outgoing • ${_formatDuration(widget.log.durationSeconds ?? 0)}';
      overlayIcon = Icons.arrow_outward;
      overlayBgColor = isDark ? const Color(0xFF10361A) : const Color(0xFFE8F5E9);
      overlayIconColor = const Color(0xFF00C853);
    } else {
      // Default
      statusColor = Colors.grey;
      statusText = widget.log.type.toString().split('.').last;
      overlayIcon = Icons.phone;
      overlayBgColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
      overlayIconColor = Colors.grey;
    }

    // Special case for design matching "Dad" example which has a "Call" button
    // We can simulate this if it's a missed call
    final showCallButton = isMissed;

    return GestureDetector(
      onTap: () {
        final notes = widget.log.notes;
        if (notes != null && notes.isNotEmpty) {
          setState(() => _isExpanded = !_isExpanded);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar with Overlay
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    widget.log.favoriteContact != null ? FavoriteAvatar(favorite: widget.log.favoriteContact!) : TextAvatar(name: widget.log.contactName),
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
                          child: Icon(overlayIcon, size: 12, color: overlayIconColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.log.contactName,
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
                            decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusText.capitalize(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                      color: isDark ? Colors.red.withAlpha(51) : const Color(0xFFFFF9E6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Call',
                      style: TextStyle(
                        color: isDark ? Colors.red : const Color(0xFFE67E22),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
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
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Divider(height: 1, color: isDark ? Colors.grey[700] : Colors.grey[300]),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.notes,
                            size: 14,
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.log.notes!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }


  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    if (minutes < 60) {
      final remainingSeconds = seconds % 60;
      return remainingSeconds > 0
          ? '${minutes}m ${remainingSeconds}s'
          : '${minutes}m';
    }
    return '${minutes}m';
  }
}
