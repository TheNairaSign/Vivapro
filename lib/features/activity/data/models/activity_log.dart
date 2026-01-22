import 'package:isar/isar.dart';

part 'activity_log.g.dart';

enum ActivityType {
  call,
  message,
  meeting,
  other,
}

@collection
class ActivityLog {
  Id id = Isar.autoIncrement;

  @Index()
  final String contactId;

  final String contactName;

  final String? phoneNumber;

  @Enumerated(EnumType.name)
  final ActivityType type;

  @Index()
  final DateTime timestamp;

  final int? durationSeconds;

  final String? notes;

  ActivityLog({
    required this.contactId,
    required this.contactName,
    required this.type,
    required this.timestamp,
    this.phoneNumber,
    this.durationSeconds,
    this.notes,
  });
}
