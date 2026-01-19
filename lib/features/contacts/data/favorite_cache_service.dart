import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';

class FavoriteCacheService {
  final Isar isar;

  FavoriteCacheService(this.isar);

  Future<void> cacheFavorites(List<FavoriteContact> favorites) async {
    await isar.writeTxn(() async {
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
}

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([
    FavoriteContactSchema,
  ],
    directory: dir.path,
  );
  return isar;
});

/// Provider for FavoriteCacheService
final favoriteCacheServiceProvider = Provider<FavoriteCacheService>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar.hasError) {
    throw isar.error!;
  }

  return FavoriteCacheService(isar.value!);
});