import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/features/auth/data/auth_user.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/features/messaging/data/chat.dart';
import 'package:vivapro/features/messaging/presentation/bloc/chat/chat_bloc.dart';
import 'package:vivapro/features/messaging/presentation/bloc/chat/chat_event.dart';
import 'package:vivapro/features/messaging/presentation/bloc/chat/chat_state.dart';
import 'package:vivapro/features/messaging/presentation/widgets/chat_item.dart';
import 'package:vivapro/features/messaging/presentation/pages/new_chat_screen.dart';

import 'dart:developer' as dev;

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.user});
  final AuthUser user;
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(LoadChatsEvent());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF5F5F5);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subtextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Messages',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Ionicons.create_outline,
                      color: GlobalColors.textThemeColor(context),
                      size: 22,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const NewChatScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: GlobalColors.containerColor(context),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: subtextColor),
                    prefixIcon: Icon(
                      Ionicons.search_outline,
                      color: subtextColor,
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (query) {
                    // TODO: Implement search functionality
                  },
                ),
              ),
            ),

            // Chat List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: GlobalColors.containerColor(context),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    dev.log("Entering message data: $state", name: "ChatUI");
                    return switch (state) {
                      ChatLoading() => Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                          color: Colors.lightBlue,
                          size: 30,
                        ),
                      ),
                      ChatLoaded(chat: final List<Chat> chat) =>
                        (chat.isEmpty)
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Ionicons.chatbubbles_outline,
                                      size: 64,
                                      color: subtextColor,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No conversations yet",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Start a new chat to get started",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: subtextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                itemCount: chat.length,
                                // separatorBuilder: (context, index) => Divider(
                                //   height: 1,
                                //   thickness: 1,
                                //   indent: 88,
                                //   color: isDark
                                //       ? Colors.grey[800]
                                //       : Colors.grey[200],
                                // ),
                                itemBuilder: (context, index) {
                                  final chatItem = chat[index];
                                  return ChatItem(chat: chatItem);
                                },
                              ),
                      ChatError(message: final message) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.alert_circle_outline,
                              size: 64,
                              color: Colors.red[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Oops! Something went wrong",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Text(
                                message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: subtextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _ => const Center(child: SizedBox.shrink()),
                    };
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
