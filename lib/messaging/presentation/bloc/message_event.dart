abstract class MessageEvent {}

class SendMessageEvent extends MessageEvent {
  final String chatId;
  final String text;

  SendMessageEvent({required this.chatId, required this.text});
}

class ReceiveMessageEvent extends MessageEvent {
  final String chatId;

  ReceiveMessageEvent({required this.chatId});
}

class ListenForMessagesEvent extends MessageEvent {
  final String chatId;

  ListenForMessagesEvent({required this.chatId});
}

class DeleteMessageEvent extends MessageEvent {
  final String chatId;
  final String messageId;

  DeleteMessageEvent({required this.chatId, required this.messageId});
}