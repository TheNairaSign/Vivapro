import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/message_failure.dart';
import 'package:vivapro/features/messaging/data/message.dart';
import 'dart:developer' as developer;

class MessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<Either<MessageFailure, Unit>> initialiseMessage() async {
    try {
      await _messaging.requestPermission();

      final token = await _messaging.getToken();
      await sendFCMToken(token);
      tokenChangeListener();

      return right(unit);
    } catch (e, s) {
      developer.log(
        'Error initialising message: $e',
        name: 'MessageRepository',
        error: e,
        stackTrace: s,
      );
      return left(
        MessageFailure('Error initialising message', error: e, stackTrace: s),
      );
    }
  }

  Future<Either<MessageFailure, Unit>> sendMessage({
    required String chatId,
    required String text,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;

      if (uid == null || uid.isEmpty) {
        developer.log('User is not authenticated', name: 'MessageRepository');
        return left(MessageFailure('User is not authenticated'));
      }

      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();

      final message = Message(
        id: messageRef.id,
        senderId: uid,
        text: text,
        createdAt: DateTime.now(),
        seenBy: [uid],
      );

      // Write message to subcollection
      await messageRef.set(message.toJson());

      // Update chat metadata
      await _firestore.collection('chats').doc(chatId).set({
        'lastMessage': text,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      developer.log('Message sent successfully', name: 'MessageRepository');
      return right(unit);
    } catch (e, s) {
      developer.log(
        'Error sending message: $e',
        name: 'MessageRepository',
        error: e,
        stackTrace: s,
      );
      return left(
        MessageFailure('Error sending message', error: e, stackTrace: s),
      );
    }
  }

  Future<Either<MessageFailure, String?>> getFcmToken() async {
    try {
      final token = await _messaging.getToken();
      return right(token);
    } catch (e, s) {
      developer.log(
        'Error getting FCM token: $e',
        name: 'MessageRepository',
        error: e,
        stackTrace: s,
      );
      return left(
        MessageFailure('Error getting FCM token', error: e, stackTrace: s),
      );
    }
  }

  Either<MessageFailure, Unit> tokenChangeListener() {
    try {
      _messaging.onTokenRefresh.listen((token) {
        sendFCMToken(token);
      });
      return right(unit);
    } catch (e, s) {
      developer.log(
        'Error setting up FCM token listener: $e',
        name: 'MessageRepository',
        error: e,
        stackTrace: s,
      );
      return left(
        MessageFailure(
          'Error setting up FCM token listener',
          error: e,
          stackTrace: s,
        ),
      );
    }
  }

  Future<Either<MessageFailure, Unit>> sendFCMToken(String? token) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        return left(MessageFailure('User not authenticated to send FCM token'));
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fcmToken': token ?? await getFcmToken(),
      });
      return right(unit);
    } catch (e, s) {
      developer.log(
        'Error sending FCM token: $e',
        name: 'MessageRepository',
        error: e,
        stackTrace: s,
      );
      return left(
        MessageFailure('Error sending FCM token', error: e, stackTrace: s),
      );
    }
  }

  Future<Either<MessageFailure, Unit>> markMessageAsSeen({
    required String chatId,
    required String messageId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
            'seenBy': FieldValue.arrayUnion([userId]),
          });
      return right(unit);
    } catch (e, s) {
      developer.log(
        'Error marking message as seen: $e',
        name: 'MessageRepository',
        error: e,
        stackTrace: s,
      );
      return left(
        MessageFailure(
          'Error marking message as seen',
          error: e,
          stackTrace: s,
        ),
      );
    }
  }

  Future<Either<MessageFailure, List<Message>>> getMessages({
    required String chatId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .get();

      final messages = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        // Ensure seenBy is handled if null in old data
        if (data['seenBy'] == null) {
          data['seenBy'] = [];
        }
        return Message.fromJson(data);
      }).toList();
      return right(messages);
    } catch (e, s) {
      developer.log(
        'Error getting messages: $e',
        name: 'MessageRepository',
        error: e,
        stackTrace: s,
      );
      return left(
        MessageFailure('Error getting messages', error: e, stackTrace: s),
      );
    }
  }

  Stream<List<Message>> messagesStream(String chatId) {
    // Streams are typically not wrapped in Either directly for their continuous nature.
    // Error handling for streams is usually done via the .handleError or .onError methods.
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList(),
        );
  }

  Future<Either<MessageFailure, Unit>> markAsSeen(
    String chatId,
    String messageId,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        return left(
          MessageFailure('User not authenticated to mark message as seen'),
        );
      }

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
            'seenBy': FieldValue.arrayUnion([uid]),
          });
      return right(unit);
    } catch (e, s) {
      developer.log(
        'Error marking message as seen: $e',
        name: 'MessageRepository',
        error: e,
        stackTrace: s,
      );
      return left(
        MessageFailure(
          'Error marking message as seen',
          error: e,
          stackTrace: s,
        ),
      );
    }
  }

  Future<Either<MessageFailure, Unit>> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
      return right(unit);
    } catch (e, s) {
      developer.log(
        'Error deleting message: $e',
        name: 'MessageRepository',
        error: e,
        stackTrace: s,
      );
      return left(
        MessageFailure('Error deleting message', error: e, stackTrace: s),
      );
    }
  }
}

final messageRepository = Provider<MessageRepository>(
  (ref) => MessageRepository(),
);
