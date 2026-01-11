import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/messaging/data/chat.dart';

import 'dart:developer' as dev;

class ChatRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Chat>> getChats() {
    return _firestore
        .collection('chats')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Chat.fromJson(doc.data())).toList(),
        )
        .handleError(
          (error, stackTrace) =>
              dev.log(error.toString(), name: "ChatRepositoryError"),
        );
  }

  Future<String> createChat(List<String> participants) async {
    final docRef = _firestore.collection('chats').doc();
    final chat = Chat(
      id: docRef.id,
      participants: participants,
      updatedAt: DateTime.now(),
    );
    await docRef.set(chat.toJson());
    return docRef.id;
  }
}

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(),
);
