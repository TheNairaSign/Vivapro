import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/enums/priority.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';

class FavoriteCacheService {
  final Isar isar;

  FavoriteCacheService(this.isar);

  Future<void> addFavorite(FavoriteContact favorite) async {
    await isar.writeTxn(() async {
      await isar.favoriteContacts.put(favorite);
    });
  }

  Future<void> cacheFavorites(List<FavoriteContact> favorites) async {
    await isar.writeTxn(() async {
      await isar.favoriteContacts.putAll(favorites);
    });
  }

  Future<void> replaceCache(List<FavoriteContact> favorites) async {
    await isar.writeTxn(() async {
      await isar.favoriteContacts.clear();
      await isar.favoriteContacts.putAll(favorites);
    });
  }

  Stream<List<FavoriteContact>> watchFavorites() {
    return isar.favoriteContacts.where().watch(fireImmediately: true);
  }

  Future<void> removeFavorite(String id) async {
    await isar.writeTxn(() async {
      await isar.favoriteContacts.deleteById(id);
    });
  }

  Future<void> clearCache() async {
    await isar.writeTxn(() async {
      await isar.favoriteContacts.clear();
    });
  }

  Future<List<FavoriteContact>> getAllFavorites() async {
    return isar.favoriteContacts.where().findAll();
  }

  Future<bool> isFavorite(String id) async {
    final favorite = await isar.favoriteContacts.where().idEqualTo(id).findFirst();
    return favorite != null;
  }

  Future<FavoriteContact?> getFavoriteById(String id) async {
    return isar.favoriteContacts.where().idEqualTo(id).findFirst();
  }

  Future<void> toggleFavorite(bool currentlyFavorite, Contact contact) async {
    if (currentlyFavorite) {
      await removeFavorite(contact.id);
    } else {
      await addFavorite(
        FavoriteContact.create(
          id: contact.id,
          contactDetails: contact,
          priority: CallPriority.low,
          callFrequency: CallFrequency.daily,
        ),
      );
    }
  }
}

/// Provider for Isar instance. Should be overridden in main.dart
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar has not been initialized');
});

/// Provider for FavoriteCacheService
final favoriteCacheServiceProvider = Provider<FavoriteCacheService>((ref) {
  final isar = ref.watch(isarProvider);
  return FavoriteCacheService(isar);
});