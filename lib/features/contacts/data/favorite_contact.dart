import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/enums/priority.dart';

class FavoriteContact {
  final String id;
  final Contact contactDetails;
  final String? inAppUserId;
  final CallPriority priority;
  final CallFrequency callFrequency;
  final DateTime? lastCalledAt;

  FavoriteContact({
    required this.id,
    required this.contactDetails,
    this.inAppUserId,
    required this.priority,
    required this.callFrequency,
    this.lastCalledAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'contactDetails': contactDetails.toJson(),
      'inAppUserId': inAppUserId,
      'priority': priority.name,
      'callFrequency': callFrequency.name,
      'lastCalledAt': lastCalledAt,
      'createdAt': FieldValue.serverTimestamp(),
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
      lastCalledAt: (map['lastCalledAt'] as Timestamp?)?.toDate(),
    );
  }
}
