sealed class ChatEvent {}

class LoadChatsEvent extends ChatEvent {}

class ClearChatEvent extends ChatEvent {}

class CreateChatEvent extends ChatEvent {
  final List<String> participants;

  CreateChatEvent(this.participants);
}
