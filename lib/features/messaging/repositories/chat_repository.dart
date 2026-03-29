import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/messaging/data/chat.dart';

import 'dart:developer' as dev;

/// Local-only placeholder for ChatRepository.
/// Firebase (Firestore) has been removed.
class ChatRepository {
  Stream<List<Chat>> getChats() {
    dev.log('getChats called (local stub)', name: 'ChatRepository');
    // TODO: implement with your chosen backend
    return Stream.value([]);
  }

  Future<String> createChat(List<String> participants) async {
    dev.log('createChat called (local stub)', name: 'ChatRepository');
    // TODO: implement with your chosen backend
    return 'local_chat_id';
  }
}

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(),
);
