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
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MessagesScreen(chat: chat))),
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple.shade50,
        child: Text(
          participants.isNotEmpty 
              ? participants.join(',').characters.first.toUpperCase() 
              : '?',
          style: TextStyle(
            color: GlobalColors.darkPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        participants.join(',').capitalize(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        chat.lastMessage ?? 'Texting with ${participants.join(',').capitalize()}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
      ),
      trailing: Icon(Icons.more_vert, color: GlobalColors.darkPurple),
    );
  }
}
