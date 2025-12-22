import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/app_constants.dart';
import 'package:vivapro/core/extensions/capitalization.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/messaging/data/chat.dart';
import 'package:vivapro/messaging/presentation/pages/messages_screen.dart';

class ChatItem extends ConsumerWidget {
  const ChatItem({super.key, required this.chat});
  final Chat chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = chat.participants;
    final name = participants.isNotEmpty ? participants.join(',').capitalize() : 'Unknown';
    final initial = participants.isNotEmpty 
        ? participants.join(',').characters.first.toUpperCase() 
        : '?';

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => MessagesScreen(chat: chat)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(AppConstants.placeHolderProfileImage),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage ?? 'Start chatting...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(chat.updatedAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle
                  ),
                  child: Text(
                    '9',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
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
    // Simple formatter, can use intl later if complex logic needed
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inDays == 0 && now.day == time.day) {
      // Show HH:mm
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else if (diff.inDays < 7) {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[time.weekday - 1];
    } else {
      return "${time.day}/${time.month}";
    }
  }
}
