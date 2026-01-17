import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/enums/priority.dart';

class FavoriteContact {
  final String? id;
  final Contact contactDetails;
  final String? inAppUserId;
  final CallPriority priority;
  final CallFrequency callFrequency;
  final DateTime? lastInteractionAt;
  final DateTime? createdAt;

  FavoriteContact({
    this.id,
    required this.contactDetails,
    this.inAppUserId,
    required this.priority,
    required this.callFrequency,
    this.lastInteractionAt,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'contactDetails': contactDetails.toJson(),
      'inAppUserId': inAppUserId,
      'priority': priority.name,
      'callFrequency': callFrequency.name,
      'lastInteractionAt': lastInteractionAt,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory FavoriteContact.fromMap(String id, Map<String, dynamic> map) {
    return FavoriteContact(
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
    String? id,
    Contact? contactDetails,
    String? inAppUserId,
    CallPriority? priority,
    CallFrequency? callFrequency,
    DateTime? lastInteractionAt,
    DateTime? createdAt,
  }) {
    return FavoriteContact(
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
