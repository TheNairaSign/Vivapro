import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/messaging/data/message.dart';
import 'dart:developer' as developer;

class MessageRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialiseMessage() async {
    try {
      await _messaging.requestPermission();

      final token = await _messaging.getToken();
      await sendFCMToken(token);
      tokenChangeListener();

    } catch (e) {
      developer.log('Error initialising message: $e', name: 'MessageRepository');
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    try {
      final uid = _auth.currentUser!.uid;

      if (uid.isEmpty) {
        developer.log('User is not authenticated', name: 'MessageRepository');
        return;
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
          seenBy: [uid]);

      // Write message to subcollection
      await messageRef.set(message.toJson());

      // Update chat metadata
      await _firestore.collection('chats').doc(chatId).set({
        'lastMessage': text,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      developer.log('Message sent successfully', name: 'MessageRepository');
     
    } catch (e) {
      developer.log('Error sending message: $e', name: 'MessageRepository');
    }
  }

  Future<String?> getFcmToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      developer.log('Error getting FCM token: $e', name: 'MessageRepository');
      return null;
    }
  }

  void tokenChangeListener() {
    try {
      _messaging.onTokenRefresh.listen(sendFCMToken);
    } catch (e) {
      developer.log('Error setting up FCM token listener: $e', name: 'MessageRepository');
    }
  }

  Future<void> sendFCMToken(String? token) async {
    try {
      final uid = _auth.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'fcmToken': token ?? await getFcmToken()});
    } catch (e) {
      developer.log('Error sending FCM token: $e', name: 'MessageRepository');
    }
  }

  Future<void> markMessageAsSeen({
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
          .update({'seenBy': FieldValue.arrayUnion([userId])});
    } catch (e) {
      developer.log('Error marking message as seen: $e', name: 'MessageRepository');
    }
  }

  Future<List<Message>> getMessages({required String chatId}) async {
    try {
      final querySnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        // Ensure seenBy is handled if null in old data
        if (data['seenBy'] == null) {
          data['seenBy'] = [];
        }
        return Message.fromJson(data);
      }).toList();
    } catch (e) {
      developer.log('Error getting messages: $e', name: 'MessageRepository');
      return [];
    }
  }
}

final messageRepository = Provider<MessageRepository>((ref) => MessageRepository());