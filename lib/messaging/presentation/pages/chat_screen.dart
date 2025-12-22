import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/auth/data/auth_user.dart';
import 'package:vivapro/core/extensions/first_name_extension.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/messaging/data/chat.dart';
import 'package:vivapro/messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:vivapro/messaging/presentation/bloc/chat/chat_event.dart';
import 'package:vivapro/messaging/presentation/bloc/chat/chat_state.dart';
import 'package:vivapro/messaging/presentation/widgets/chat_item.dart';

import 'package:vivapro/messaging/presentation/pages/new_chat_screen.dart';

import 'dart:developer' as dev;

import 'package:vivapro/messaging/presentation/widgets/chat_search_bar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.user});
  final AuthUser user;
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(LoadChatsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Chats"),
        actions: [
          IconButton(
            icon: const Icon(Ionicons.archive_outline),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Ionicons.create_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ChatSearchBar(),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  dev.log("Entering message data: $state", name: "ChatUI");
                  return switch (state) {
                    ChatLoading() => const Center(child: CircularProgressIndicator()),
                    ChatLoaded(chat: final List<Chat> chat) => (chat.isEmpty) 
                    ? Center(child: Text("No chats", style: Theme.of(context).textTheme.titleMedium)) 
                    : ListView.separated(
                        // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                        itemCount: chat.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final chatItem = chat[index];
                          return Column(
                            children: [
                              ChatItem(chat: chatItem),
                              if (chat.length > 1)
                                Divider(
                                  height: 1,
                                  endIndent: 0,
                                  color: Colors.grey[100],
                                ),
                            ],
                          );
                        },
                      ),
                    ChatError(message: final message) => Center(child: Text(message)),
                    _ => const Center(child: SizedBox.shrink()),
                  };
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryItem({bool isAdd = false, required String name, Color? color}) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isAdd 
                ? Border.all(color: Colors.grey.shade700, style: BorderStyle.solid) 
                : Border.all(color: color ?? Colors.grey, width: 2),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isAdd ? Colors.transparent : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: isAdd 
                ? const Icon(Icons.add, color: Colors.white)
                : Icon(Icons.person, color: color?.withValues(alpha: 0.5) ?? Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
