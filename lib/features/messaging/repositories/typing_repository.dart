import 'dart:developer' as developer;

/// Local-only placeholder for TypingRepository.
/// Firebase (Firestore) has been removed.
class TypingRepository {
  void startTyping(String chatId) {
    developer.log('startTyping: $chatId (local stub)', name: 'TypingRepository');
    // TODO: implement with your chosen backend
  }

  void stopTyping(String chatId) {
    developer.log('stopTyping: $chatId (local stub)', name: 'TypingRepository');
    // TODO: implement with your chosen backend
  }

  Stream<Map<String, dynamic>> typingListener(String chatId) {
    // TODO: implement with your chosen backend
    return Stream.value({});
  }
}
