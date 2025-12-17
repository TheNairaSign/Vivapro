import 'package:vivapro/messaging/data/chat.dart';

sealed class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chat;

  ChatLoaded(this.chat);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}