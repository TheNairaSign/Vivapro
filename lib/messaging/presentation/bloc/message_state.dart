import 'package:vivapro/messaging/data/message.dart';

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<Message> messages;

  MessageLoaded(this.messages);
}

class MessageSendSuccess extends MessageState {}

class MessageStreamFailure extends MessageState {
  final String message;
  final StackTrace stackTrace;
        
  MessageStreamFailure(this.message, this.stackTrace);
}

class MessageSendFailure extends MessageState {
  final String message;

  MessageSendFailure(this.message);
}