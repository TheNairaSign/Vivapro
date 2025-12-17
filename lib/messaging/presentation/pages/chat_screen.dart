import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/messaging/data/chat.dart';
import 'package:vivapro/messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:vivapro/messaging/presentation/bloc/chat/chat_event.dart';
import 'package:vivapro/messaging/presentation/bloc/chat/chat_state.dart';
import 'package:vivapro/messaging/presentation/widgets/chat_item.dart';

import 'package:vivapro/messaging/presentation/pages/new_chat_screen.dart';

import 'dart:developer' as dev;

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

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
    final borderColor = Colors.white;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Messages", style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: GlobalColors.darkPurple),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: GlobalColors.darkPurple),
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          dev.log("Entering message data: $state", name: "ChatUI");
          return switch (state) {
            ChatLoading() => const Center(child: CircularProgressIndicator()),
            ChatLoaded(chat: final List<Chat> chat) => (chat.isEmpty) ? Center(child: Text("No chats", style: Theme.of(context).textTheme.titleMedium)) : ListView.builder(
                itemCount: chat.length,
                itemBuilder: (context, index) {
                  debugPrint("Chat: ${chat[index].toString()}");
                  final chatItem = chat[index];
                  return ChatItem(chat: chatItem);
                },
              ),
            ChatError(message: final message) => Center(child: Text(message)),
            _ => const Center(child: SizedBox.shrink()),
          };
        }
      ),
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NewChatScreen())),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: GlobalColors.yellow,
            border: BorderDirectional(
              top: BorderSide(
                color:borderColor,
                width: 1,
              ),
              bottom: BorderSide(
                color:borderColor,
                width: 8,
              ),
              start: BorderSide(
                color:borderColor,
                width: 2,
              ),
              end: BorderSide(
                color:borderColor,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: GlobalColors.darkPurple),
              const SizedBox(width: 10),
              Text(
                "New Chat",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: GlobalColors.darkPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
