class Chat {
  final String id;
  final List<String> participants;
  final String? lastMessage;
  final DateTime updatedAt;

  Chat({
    required this.id,
    required this.participants,
    this.lastMessage,
    required this.updatedAt,
  });

  Chat copyWith({
    String? id,
    List<String>? participants,
    String? lastMessage,
    DateTime? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      participants: List<String>.from(json['participants'] as List),
      lastMessage: json['lastMessage'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Chat(id: $id, participants: $participants, lastMessage: $lastMessage, updatedAt: $updatedAt)';
  }
}
