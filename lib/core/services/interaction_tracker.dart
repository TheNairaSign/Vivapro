import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';

/// Service responsible for tracking interactions with favorite contacts
/// This is the primary method for updating lastInteractionAt timestamps
class InteractionTracker {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  InteractionTracker(
    this._firestore,
    this._auth,
  );

  /// Record an interaction with a favorite contact
  /// This is called when the user initiates a call from within the app
  Future<void> recordInteraction(String contactId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final now = DateTime.now();
    
    try {
      // Update the lastInteractionAt timestamp in Firestore
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(contactId)
          .update({
        'lastInteractionAt': Timestamp.fromDate(now),
      });
    } catch (e) {
      // If the document doesn't exist, we can't update it
      // This is fine - the contact might not be a favorite
      print('Error recording interaction: $e');
    }
  }

  /// Record an interaction for a specific favorite contact object
  Future<void> recordInteractionForContact(FavoriteContact contact) async {
    if (contact.id == null) return;
    await recordInteraction(contact.id!);
  }

  /// Manually set the last interaction time (useful for importing call history)
  Future<void> setLastInteraction(
    String contactId,
    DateTime interactionTime,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(contactId)
          .update({
        'lastInteractionAt': Timestamp.fromDate(interactionTime),
      });
    } catch (e) {
      print('Error setting last interaction: $e');
    }
  }

  /// Get the last interaction time for a contact
  Future<DateTime?> getLastInteraction(String contactId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .doc(contactId)
          .get();

      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null) return null;

      final timestamp = data['lastInteractionAt'] as Timestamp?;
      return timestamp?.toDate();
    } catch (e) {
      print('Error getting last interaction: $e');
      return null;
    }
  }
}

/// Provider for the interaction tracker
final interactionTrackerProvider = Provider<InteractionTracker>((ref) {
  return InteractionTracker(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});
