import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/core/app_constants.dart';
import 'package:vivapro/core/extensions/capitalization.dart';
import 'package:vivapro/messaging/data/chat.dart';
import 'package:vivapro/messaging/presentation/pages/messages_screen.dart';

class ChatItem extends ConsumerWidget {
  const ChatItem({super.key, required this.chat});
  final Chat chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final participants = chat.participants;
    final name = participants.isNotEmpty ? participants.join(',').capitalize() : 'Unknown';
    final initial = participants.isNotEmpty 
        ? participants.join(',').characters.first.toUpperCase() 
        : '?';

    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subtextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final timeColor = isDark ? Colors.grey[500] : const Color(0xFF4A9EFF);

    // Simulate unread status (you can replace this with actual logic)
    final hasUnread = chat.lastMessage?.isNotEmpty ?? false;
    final showCallIcon = name.toLowerCase().contains('mom') || name.toLowerCase().contains('dad');

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => MessagesScreen(chat: chat)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                  backgroundImage: const CachedNetworkImageProvider(
                    AppConstants.placeHolderProfileImage,
                  ),
                ),
                // Online indicator (optional)
                if (name.toLowerCase().contains('mom'))
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Name and Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage ?? 'Start chatting...',
                    style: TextStyle(
                      fontSize: 14,
                      color: subtextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            
            // Time and Indicators
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      _formatTime(chat.updatedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: timeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (showCallIcon) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Ionicons.call,
                        size: 16,
                        color: subtextColor,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                // Unread indicator
                if (hasUnread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A9EFF),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24 && now.day == time.day) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[time.weekday - 1];
    } else {
      return "${time.day}/${time.month}";
    }
  }
}

