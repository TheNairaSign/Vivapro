import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/contacts/repositories/contact_repository.dart';
import 'package:vivapro/messaging/presentation/bloc/chat/chat_event.dart';
import 'package:vivapro/messaging/presentation/bloc/chat/chat_state.dart';
import 'package:vivapro/messaging/repositories/chat_repository.dart';

import 'dart:developer' as dev;

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepo;
  final ContactRepository contactRepository;

  ChatBloc(this.chatRepo, this.contactRepository) : super(ChatInitial()) {
    on<LoadChatsEvent>(loadChats);
    on<ClearChatEvent>(clearChat);
    on<CreateChatEvent>(_createChat);
  }

  Future<void> loadChats(LoadChatsEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    await emit.forEach(
      chatRepo.getChats(), 
      onData: (chats) => ChatLoaded(chats),
      onError: (error, stackTrace) => ChatError(error.toString()),
    ).then((value) => emit(ChatInitial())).catchError((error) => emit(ChatError(error.toString())));
  }

  Future<void> clearChat(ClearChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatInitial());
  }

  Future<void> _createChat(CreateChatEvent event, Emitter<ChatState> emit) async {
    try {
      final contactNames = await contactRepository.matchContactIdToName(event.participants);
      dev.log("Contact names: $contactNames", name: "ChatBloc");
      await chatRepo.createChat(contactNames);
      emit(ChatInitial());
      // We don't need to emit loaded here because the stream subscription in loadChats should pick it up if active.
      // But typically we might want to navigate or show success.
      // For now, just let the stream handle updates.
    } catch (e) {
      dev.log("Error creating chat: $e", name: "ChatBloc");
      // Handle error if needed, maybe show a snackbar via listener in UI
      // emit(ChatError(e.toString())); // Careful not to break the stream state if we are creating
    }
  }
}