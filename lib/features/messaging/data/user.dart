class User {
  final String id;
  final String name;
  final String photoUrl;
  final bool online;
  final DateTime lastSeen;

  User({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.online,
    required this.lastSeen,
  });

  User copyWith({
    String? id,
    String? name,
    String? photoUrl,
    bool? online,
    DateTime? lastSeen,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      online: online ?? this.online,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'online': online,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String,
      online: json['online'] as bool,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
    );
  }
}
