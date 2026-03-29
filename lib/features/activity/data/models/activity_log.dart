import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';

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

  final String? favoriteDetailsJson;

  @ignore
  final FavoriteContact? favoriteContact;

  final String? phoneNumber;

  @Enumerated(EnumType.name)
  final ActivityType type;

  @Index()
  final DateTime timestamp;

  final int? durationSeconds;

  final String? notes;

  /// Whether the interaction was incoming (true) or outgoing (false)
  final bool isIncoming;

  /// Whether this was logged manually by the user
  final bool isManual;

  ActivityLog({
    required this.contactId,
    required this.contactName,
    required this.type,
    required this.timestamp,
    this.phoneNumber,
    this.durationSeconds,
    this.notes,
    String? favoriteDetailsJson,
    FavoriteContact? favoriteContact,
    this.isIncoming = false,
    this.isManual = false,
  })  : favoriteDetailsJson = favoriteDetailsJson ??
            (favoriteContact != null
                ? jsonEncode(favoriteContact.toJson())
                : null),
        favoriteContact = favoriteContact ??
            (favoriteDetailsJson != null
                ? FavoriteContact.fromJson(jsonDecode(favoriteDetailsJson))
                : null);

  /// Factory to create a log from a FavoriteContact object
  factory ActivityLog.create({
    required FavoriteContact favorite,
    required ActivityType type,
    DateTime? timestamp,
    String? notes,
    int? durationSeconds,
    String? phoneNumber,
    bool isIncoming = false,
    bool isManual = false,
  }) {
    return ActivityLog(
      contactId: favorite.id,
      contactName: favorite.contactDetails.displayName ?? 'John Doe',
      type: type,
      timestamp: timestamp ?? DateTime.now(),
      notes: notes,
      durationSeconds: durationSeconds,
      phoneNumber: phoneNumber ??
          (favorite.contactDetails.phones.isNotEmpty
              ? favorite.contactDetails.phones.first.number
              : null),
      favoriteDetailsJson: jsonEncode(favorite.toJson()),
      isIncoming: isIncoming,
      isManual: isManual,
    );
  }

  /// Getters for UI convenience
  @ignore
  bool get isMissed => type == ActivityType.call && !isIncoming && (durationSeconds == null || durationSeconds == 0);

  @ignore
  String get formattedDuration {
    if (durationSeconds == null || durationSeconds == 0) return '';
    final seconds = durationSeconds!;
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes < 60) {
      return remainingSeconds > 0 ? '${minutes}m ${remainingSeconds}s' : '${minutes}m';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return remainingMinutes > 0 ? '${hours}h ${remainingMinutes}m' : '${hours}h';
  }

  ActivityLog copyWith({
    String? contactId,
    String? contactName,
    String? profilePhotoUrl,
    String? favoriteDetailsJson,
    String? phoneNumber,
    ActivityType? type,
    DateTime? timestamp,
    int? durationSeconds,
    String? notes,
    bool? isIncoming,
    bool? isManual,
  }) {
    return ActivityLog(
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      favoriteDetailsJson: favoriteDetailsJson ?? this.favoriteDetailsJson,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      notes: notes ?? this.notes,
      isIncoming: isIncoming ?? this.isIncoming,
      isManual: isManual ?? this.isManual,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactId': contactId,
      'contactName': contactName,
      'favoriteDetailsJson': favoriteDetailsJson,
      'phoneNumber': phoneNumber,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'durationSeconds': durationSeconds,
      'notes': notes,
      'isIncoming': isIncoming,
      'isManual': isManual,
    };
  }

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      contactId: json['contactId'],
      contactName: json['contactName'],
      favoriteDetailsJson: json['favoriteDetailsJson'],
      phoneNumber: json['phoneNumber'],
      type: ActivityType.values.firstWhere((e) => e.name == json['type']),
      timestamp: DateTime.parse(json['timestamp']),
      durationSeconds: json['durationSeconds'],
      notes: json['notes'],
      isIncoming: json['isIncoming'] ?? false,
      isManual: json['isManual'] ?? false,
    );
  }
}
