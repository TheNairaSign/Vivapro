import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final List<String> seenBy;

  Message({
    this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
    required this.seenBy,
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? text,
    DateTime? createdAt,
    List<String>? seenBy,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      seenBy: seenBy ?? this.seenBy,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'createdAt': createdAt,
      'seenBy': seenBy,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      seenBy: List<String>.from(json['seenBy'] as List),
    );
  }
}
