import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  late String name;
  late String email;
  String? photoUrl;
  DateTime? lastBackup;

  UserProfile({
    required this.name,
    required this.email,
    this.photoUrl,
    this.lastBackup,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'lastBackup': lastBackup?.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String,
        email: json['email'] as String,
        photoUrl: json['photoUrl'] as String?,
        lastBackup: json['lastBackup'] != null ? DateTime.parse(json['lastBackup'] as String) : null,
      );
}
