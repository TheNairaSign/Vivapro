import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/message_failure.dart';
import 'package:vivapro/features/messaging/data/message.dart';
import 'dart:developer' as developer;

/// Local-only placeholder for MessageRepository.
/// Firebase (Firestore + FCM) has been removed.
/// Replace the method bodies with your new backend when ready.
class MessageRepository {
  Future<Either<MessageFailure, Unit>> sendMessage({
    required String chatId,
    required String text,
  }) async {
    try {
      developer.log('sendMessage: chatId=$chatId', name: 'MessageRepository');
      // TODO: implement with your chosen backend
      return right(unit);
    } catch (e, s) {
      return left(MessageFailure('Error sending message', error: e, stackTrace: s));
    }
  }

  Future<Either<MessageFailure, List<Message>>> getMessages({
    required String chatId,
  }) async {
    try {
      developer.log('getMessages: chatId=$chatId', name: 'MessageRepository');
      // TODO: implement with your chosen backend
      return right([]);
    } catch (e, s) {
      return left(MessageFailure('Error getting messages', error: e, stackTrace: s));
    }
  }

  Stream<List<Message>> messagesStream(String chatId) {
    // TODO: implement with your chosen backend
    return Stream.value([]);
  }

  Future<Either<MessageFailure, Unit>> markMessageAsSeen({
    required String chatId,
    required String messageId,
    required String userId,
  }) async {
    try {
      developer.log('markAsSeen: $messageId', name: 'MessageRepository');
      return right(unit);
    } catch (e, s) {
      return left(
        MessageFailure('Error marking message as seen', error: e, stackTrace: s),
      );
    }
  }

  Future<Either<MessageFailure, Unit>> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      developer.log('deleteMessage: $messageId', name: 'MessageRepository');
      return right(unit);
    } catch (e, s) {
      return left(
        MessageFailure('Error deleting message', error: e, stackTrace: s),
      );
    }
  }
}

final messageRepository = Provider<MessageRepository>(
  (ref) => MessageRepository(),
);
