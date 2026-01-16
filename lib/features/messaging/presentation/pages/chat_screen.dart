import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/features/auth/data/auth_user.dart';
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
    final theme = Theme.of(context);
    final subtextColor = theme.brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600];

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
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      EvaIcons.edit2Outline,
                      color: theme.colorScheme.onSurface,
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
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(color: subtextColor),
                    prefixIcon: Icon(
                      EvaIcons.searchOutline,
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
                  color: theme.colorScheme.surface,
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
                          color: theme.colorScheme.primary,
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
                                      EvaIcons.messageSquareOutline,
                                      size: 64,
                                      color: subtextColor,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No conversations yet",
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Start a new chat to get started",
                                      style: theme.textTheme.bodyMedium?.copyWith(
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
                              EvaIcons.alertCircleOutline,
                              size: 64,
                              color: Colors.red[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Oops! Something went wrong",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
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
                                style: theme.textTheme.bodyMedium?.copyWith(
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
