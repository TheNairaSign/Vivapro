import 'package:flutter/material.dart';
import 'package:vivapro/messaging/data/chat.dart';

class MessagesScreen extends StatelessWidget {
  final Chat chat;
  const MessagesScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chat.participants.join(", ")),
      ),
      body: const Center(child: Text("Chat Room")),
    );
  }
}