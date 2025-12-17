import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/messaging/data/message.dart';
import 'package:vivapro/messaging/presentation/bloc/message_event.dart';
import 'package:vivapro/messaging/presentation/bloc/message_state.dart';
import 'package:vivapro/messaging/repositories/message_repository.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository messageRepository;

  MessageBloc(this.messageRepository) : super(MessageInitial()) {
    on<SendMessageEvent>(sendMessage);
    on<DeleteMessageEvent>(deleteMessage);
    on<ListenForMessagesEvent>(listenForMessage);
  }

  Future<void> listenForMessage(ListenForMessagesEvent event, Emitter<MessageState> emit) async {
    await emit.forEach<List<Message>>(
        messageRepository.messagesStream(event.chatId),
        onData: (messages) => MessageLoaded(messages),
        onError: (error, stackTrace) => MessageStreamFailure(error.toString(), stackTrace),
      );
  }
  
  Future<void> sendMessage(SendMessageEvent event, Emitter<MessageState> emit) async {
    try {
      final send = await messageRepository.sendMessage(chatId: event.chatId, text: event.text);
      emit(send.fold(
        (failure) => MessageSendFailure(failure.message),
        (success) => MessageSendSuccess(),
      ));
    } catch (e) {
      emit(MessageSendFailure('Error sending message: ${e.toString()}'));
    }
  }

  Future<void> deleteMessage(DeleteMessageEvent event, Emitter<MessageState> emit) async {
    try {
      final delete = await messageRepository.deleteMessage(chatId: event.chatId, messageId: event.messageId);
      emit(delete.fold(
        (failure) => MessageSendFailure(failure.message), 
        (success) => MessageSendSuccess()
      ));
    } catch (e) {
      emit(MessageSendFailure('Error deleting message: ${e.toString()}'));
    }
  }
}