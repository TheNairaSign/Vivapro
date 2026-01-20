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

  /// Reference to the current user's favorites collection
  CollectionReference<Map<String, dynamic>> _getFavoritesRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  /// Adds a new contact to the user's favorites
  Future<void> addFavorite(FavoriteContact contact) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    
    await _getFavoritesRef(uid).doc(contact.id).set(contact.toMap());
  }

  /// Removes a contact from the user's favorites
  Future<void> removeFavorite(String contactId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    
    await _getFavoritesRef(uid).doc(contactId).delete();
  }

  /// Checks if a specific contact is already in favorites
  Future<bool> isFavorite(String contactId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    
    final doc = await _getFavoritesRef(uid).doc(contactId).get();
    return doc.exists;
  }

  /// Toggles the favorite status of a contact
  Future<void> toggleFavorite(bool currentlyFavorite, Contact contact) async {
    if (currentlyFavorite) {
      await removeFavorite(contact.id);
    } else {
      final favorite = FavoriteContact.create(
        id: contact.id,
        contactDetails: contact,
        priority: CallPriority.low,
        callFrequency: CallFrequency.daily,
      );
      await addFavorite(favorite);
    }
  }

  /// Watches all favorite contacts for the currently authenticated user
  Stream<List<FavoriteContact>> watchFavorites() {
    return _auth.authStateChanges().switchMap((user) {
      if (user == null) {
        return Stream.value(<FavoriteContact>[]);
      }
      
      return _getFavoritesRef(user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FavoriteContact.fromMap(doc.id, doc.data()))
              .toList());
    }).handleError((error) {
      developer.log('Error watching favorites: $error');
      // On error, we emit an empty list of the correct type
    });
  }

  /// Watches the favorite status of a specific contact
  Stream<bool> watchIsFavorite(String contactId) {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(false);
    
    return _getFavoritesRef(uid)
        .doc(contactId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<List<FavoriteContact>> fetchAllFavorites() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    
    final snapshot = await _getFavoritesRef(uid).get();
    return snapshot.docs
        .map((doc) => FavoriteContact.fromMap(doc.id, doc.data()))
        .toList();
  }
}

extension _StreamExtension<T> on Stream<T> {
  Stream<R> switchMap<R>(Stream<R> Function(T) mapper) {
    return map(mapper).asyncExpand((stream) => stream);
  }
}

final favoritesRepository = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
});
