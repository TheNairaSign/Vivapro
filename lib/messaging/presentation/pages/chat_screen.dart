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
    return Scaffold(
      backgroundColor: GlobalColors.navBarBlack, // Dark background for the top part
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom Header & Stories Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome Back", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                          const SizedBox(height: 4),
                          const Text(
                            "Chatdong", 
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 28, 
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.notifications_outlined, color: Colors.white),
                          ),
                          const Positioned(
                            top: 10,
                            right: 12,
                            child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Recent Chat Section (White Sheet)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Recent Chat",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9C4), // Light yellow
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.archive_outlined, size: 16, color: Colors.black87),
                                SizedBox(width: 4),
                                Text("Archive Chat", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<ChatBloc, ChatState>(
                        builder: (context, state) {
                          dev.log("Entering message data: $state", name: "ChatUI");
                          return switch (state) {
                            ChatLoading() => const Center(child: CircularProgressIndicator()),
                            ChatLoaded(chat: final List<Chat> chat) => (chat.isEmpty) 
                            ? Center(child: Text("No chats", style: Theme.of(context).textTheme.titleMedium)) 
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                                itemCount: chat.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final chatItem = chat[index];
                                  return ChatItem(chat: chatItem);
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
                : Icon(Icons.person, color: color?.withOpacity(0.5) ?? Colors.grey),
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
