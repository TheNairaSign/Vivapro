import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/enums/priority.dart';

import 'dart:developer' as developer;

class FavoritesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FavoritesRepository(this._firestore, this._auth);

  Future<void> addFavorite(FavoriteContact contact) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final favoritesRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites');
    await favoritesRef.doc(contact.id).set(contact.toMap());
  }

  /// Remove favorite contact
  Future<void> removeFavorite(String contactId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final favoritesRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites');
    await favoritesRef.doc(contactId).delete();
  }

  /// Check if contact is favorite
  Future<bool> isFavorite(String contactId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    final favoritesRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites');
    final doc = await favoritesRef.doc(contactId).get();
    return doc.exists;
  }

  Future<void> toggleFavorite(bool isFavorite, Contact contact) async {
    if (isFavorite) {
      await removeFavorite(contact.id);
    } else {
      final favorite = FavoriteContact(
        id: contact.id,
        contactDetails: contact,
        priority: CallPriority.low,
        callFrequency: CallFrequency.daily,
      );
      await addFavorite(favorite);
    }
    // setState(() {}); // Refresh icon
  }

  /// Listen to favorites
  Stream<List<FavoriteContact>> watchFavorites() {
    final controller = StreamController<List<FavoriteContact>>();
    StreamSubscription? favoritesSubscription;

    final authSubscription = _auth.authStateChanges().listen((user) {
      favoritesSubscription?.cancel();
      if (user == null) {
        controller.add([]);
      } else {
        final favoritesRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites');
        favoritesSubscription = favoritesRef
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
            .map((doc) => FavoriteContact.fromMap(doc.id, doc.data()))
            .toList(),
          )
          .listen(controller.add, onError: controller.addError);
      }
      favoritesSubscription?.onError((error) => developer.log('Error listening to favorites: $error'));
    });

    controller.onCancel = () {
      favoritesSubscription?.cancel();
      authSubscription.cancel();
    };

    return controller.stream;
  }

  Stream<bool> watchIsFavorite(String contactId) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(false);
    final favoritesRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites');
    return favoritesRef.doc(contactId).snapshots().map((doc) => doc.exists);
  }
}

final favoritesRepository = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
});
