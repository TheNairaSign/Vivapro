import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:vivapro/features/messaging/data/chat.dart';

class MessagesScreen extends StatelessWidget {
  final Chat chat;
  const MessagesScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        EvaIcons.arrowBack,
                        color: theme.colorScheme.onBackground,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://avatar.iran.liara.run/public/27",
                    ),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // chat.participants.join(", "),
                        "Rehan Wangsaff", // Mocking name to match image
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Online",
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(EvaIcons.moreVertical, color: theme.colorScheme.onBackground),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Message Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Date Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Today",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        children: [
                          _buildReceivedMessage(
                            context,
                            "HI, I'm heading to the mall this afternoon",
                            "01.12",
                          ),
                          _buildReceivedMessage(
                            context,
                            "Do you wanna join with me?",
                            "01.12",
                          ),
                          _buildSentMessage(context, "its look awesome!", "01.23"),
                          _buildSentMessage(
                            context,
                            "But can I bring my girlfriend? They want to go to the mall",
                            "01.23",
                          ),
                          _buildReceivedMessage(context, "of course just him", "01.34"),
                          _buildSentMessage(context, "Thanks Rehan", "01.35"),
                          _buildReceivedMessage(context, "Ur Welcome!", "01.38"),
                        ],
                      ),
                    ),
                    // Input Area
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 40,
                        top: 10,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                EvaIcons.mic,
                                color: theme.colorScheme.secondary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Message...",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                EvaIcons.paperPlane,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildReceivedMessage(BuildContext context, String text, String time) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 4),
          Text(time, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, String text, String time) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 4),
          Text(time, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}
