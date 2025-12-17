import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return ListTile(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MessagesScreen(chat: chat))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading:  CircleAvatar(
        backgroundImage: NetworkImage("https://avatar.iran.liara.run/public/27"),
      ),
      title: Text(
        name,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: GlobalColors.darkPurple,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          chat.lastMessage ?? 'Start chatting...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              color: GlobalColors.peach,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              '9',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
