import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:developer' as developer;

class TypingRepository {
  final _firestore = FirebaseFirestore.instance;

  void startTyping(String chatId) {
    final value = _firestore.collection('typing').doc(chatId).set({
      'userId': true,
    }, SetOptions(merge: true));
    value.then(
      (value) => developer.log("Typing started", name: "TypingRepository"),
    );
    value.catchError(
      (error) =>
          developer.log("Typing started failed", name: "TypingRepository"),
    );
  }

  void stopTyping(String chatId) {
    final value = _firestore.collection('typing').doc(chatId).update({
      'userId': FieldValue.delete(),
    });
    value.then(
      (value) => developer.log("Typing stopped", name: "TypingRepository"),
    );
    value.catchError(
      (error) =>
          developer.log("Typing stopped failed", name: "TypingRepository"),
    );
  }

  Stream<DocumentSnapshot> typingListener(String chatId) {
    return _firestore.collection('typing').doc(chatId).snapshots();
  }
}
