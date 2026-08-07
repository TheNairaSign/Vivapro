import 'dart:convert';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:isar/isar.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/enums/priority.dart';

part 'favorite_contact.g.dart';

@collection
class FavoriteContact {
  /// Local Isar ID
  Id isarId;

  /// The unique identifier for the contact (usually from flutter_contacts or Firestore)
  @Index(unique: true)
  final String id;

  final String? inAppUserId;
  
  @Enumerated(EnumType.name)
  final CallPriority priority;
  
  @Enumerated(EnumType.name)
  final CallFrequency callFrequency;
  
  final DateTime? lastInteractionAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Internal field for Isar to store the contact details
  final String contactDetailsJson;
  final String? profilePhotoUrl;

  /// ISO weekday(s) (1=Mon..7=Sun) this contact should be checked up on.
  /// Used by [CallFrequency.weekly] and, optionally, [CallFrequency.custom].
  final List<int>? checkupWeekdays;

  /// Day(s) of month (1-31) this contact should be checked up on.
  /// Used by [CallFrequency.monthly] and, optionally, [CallFrequency.custom].
  final List<int>? checkupMonthDays;

  @ignore
  late final Contact contactDetails;

  FavoriteContact({
    this.isarId = Isar.autoIncrement,
    required this.id,
    this.inAppUserId,
    required this.priority,
    required this.callFrequency,
    this.lastInteractionAt,
    this.createdAt,
    this.updatedAt,
    required this.contactDetailsJson,
    this.profilePhotoUrl,
    this.checkupWeekdays,
    this.checkupMonthDays,
  }) : contactDetails = Contact.fromJson(jsonDecode(contactDetailsJson));

  /// Factory constructor to create a FavoriteContact from a Contact object
  factory FavoriteContact.create({
    Id isarId = Isar.autoIncrement,
    required String id,
    required Contact contactDetails,
    String? inAppUserId,
    required CallPriority priority,
    required CallFrequency callFrequency,
    DateTime? lastInteractionAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profilePhotoUrl,
    List<int>? checkupWeekdays,
    List<int>? checkupMonthDays,
  }) {
    return FavoriteContact(
      isarId: isarId,
      id: id,
      contactDetailsJson: jsonEncode(contactDetails.toJson()),
      inAppUserId: inAppUserId,
      priority: priority,
      callFrequency: callFrequency,
      lastInteractionAt: lastInteractionAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      profilePhotoUrl: profilePhotoUrl,
      checkupWeekdays: checkupWeekdays,
      checkupMonthDays: checkupMonthDays,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contactDetails': contactDetails.toJson(),
      'inAppUserId': inAppUserId,
      'priority': priority.name,
      'callFrequency': callFrequency.name,
      'lastInteractionAt': lastInteractionAt,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': (updatedAt ?? DateTime.now()).toIso8601String(),
      'profilePhotoUrl': profilePhotoUrl,
      'checkupWeekdays': checkupWeekdays,
      'checkupMonthDays': checkupMonthDays,
    };
  }

  factory FavoriteContact.fromMap(String id, Map<String, dynamic> map) {
    return FavoriteContact.create(
      id: id,
      contactDetails: Contact.fromJson(map['contactDetails']),
      inAppUserId: map['inAppUserId'],
      priority: CallPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => CallPriority.low,
      ),
      callFrequency: CallFrequency.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            (map['callFrequency'] as String?)?.toLowerCase(),
        orElse: () => CallFrequency.daily,
      ),
      lastInteractionAt: map['lastInteractionAt'] != null
          ? DateTime.parse(map['lastInteractionAt'] as String)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      profilePhotoUrl: map['profilePhotoUrl'],
      checkupWeekdays: (map['checkupWeekdays'] as List?)?.cast<int>(),
      checkupMonthDays: (map['checkupMonthDays'] as List?)?.cast<int>(),
    );
  }

  FavoriteContact copyWith({
    Id? isarId,
    String? id,
    String? inAppUserId,
    CallPriority? priority,
    CallFrequency? callFrequency,
    DateTime? lastInteractionAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? contactDetailsJson,
    String? profilePhotoUrl,
    List<int>? checkupWeekdays,
    List<int>? checkupMonthDays,
  }) {
    return FavoriteContact(
      isarId: isarId ?? this.isarId,
      id: id ?? this.id,
      inAppUserId: inAppUserId ?? this.inAppUserId,
      priority: priority ?? this.priority,
      callFrequency: callFrequency ?? this.callFrequency,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contactDetailsJson: contactDetailsJson ?? this.contactDetailsJson,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      checkupWeekdays: checkupWeekdays ?? this.checkupWeekdays,
      checkupMonthDays: checkupMonthDays ?? this.checkupMonthDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactDetails': contactDetails.toJson(),
      'inAppUserId': inAppUserId,
      'priority': priority.name,
      'callFrequency': callFrequency.name,
      'lastInteractionAt': lastInteractionAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'profilePhotoUrl': profilePhotoUrl,
      'checkupWeekdays': checkupWeekdays,
      'checkupMonthDays': checkupMonthDays,
    };
  }

  factory FavoriteContact.fromJson(Map<String, dynamic> json) {
    return FavoriteContact.create(
      id: json['id'],
      contactDetails: Contact.fromJson(json['contactDetails']),
      inAppUserId: json['inAppUserId'],
      priority: CallPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => CallPriority.low,
      ),
      callFrequency: CallFrequency.values.firstWhere(
        (e) => e.name == json['callFrequency'],
        orElse: () => CallFrequency.daily,
      ),
      lastInteractionAt: json['lastInteractionAt'] != null ? DateTime.parse(json['lastInteractionAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      profilePhotoUrl: json['profilePhotoUrl'],
      checkupWeekdays: (json['checkupWeekdays'] as List?)?.cast<int>(),
      checkupMonthDays: (json['checkupMonthDays'] as List?)?.cast<int>(),
    );
  }
}
