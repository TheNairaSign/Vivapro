import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart' hide Index;
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

  /// Internal field for Isar to store the contact details
  final String contactDetailsJson;

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
    required this.contactDetailsJson,
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
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
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
      lastInteractionAt: (map['lastInteractionAt'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  FavoriteContact copyWith({
    Id? isarId,
    String? id,
    Contact? contactDetails,
    String? inAppUserId,
    CallPriority? priority,
    CallFrequency? callFrequency,
    DateTime? lastInteractionAt,
    DateTime? createdAt,
  }) {
    return FavoriteContact.create(
      isarId: isarId ?? this.isarId,
      id: id ?? this.id,
      contactDetails: contactDetails ?? this.contactDetails,
      inAppUserId: inAppUserId ?? this.inAppUserId,
      priority: priority ?? this.priority,
      callFrequency: callFrequency ?? this.callFrequency,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
