import 'package:dartz/dartz.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/repositories/favorite_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

class FavoriteManager {
  final FavoriteCacheService local;
  final FavoritesRepository remote;

  FavoriteManager({
    required this.local,
    required this.remote,
  });

  // 1. Sync: Local -> Remote (Conflict Resolution: Last Write Wins)
  Future<Either<Failure, Unit>> syncAllToCloud() async {
    try {
      final localData = await local.getAllFavorites();
      final remoteData = await remote.fetchAllFavorites();

      final remoteMap = {for (var f in remoteData) f.id: f};

      for (var localFav in localData) {
        final remoteFav = remoteMap[localFav.id];
        
        if (remoteFav == null || (localFav.updatedAt != null && (remoteFav.updatedAt == null || localFav.updatedAt!.isAfter(remoteFav.updatedAt!)))) {
           await remote.addFavorite(localFav);
        }
      }
      return right(unit);
    } catch (e) {
      developer.log('Error syncing favorites: $e', name: 'FavoriteManager');
      return left(Failure(e.toString()));
    }
  }

  // 2. Restore: Remote -> Local
  Future<Either<Failure, Unit>> restoreFromCloud() async {
    try {
      final remoteData = await remote.fetchAllFavorites();
      await local.replaceCache(remoteData);
      return right(unit);
    } catch (e) {
      developer.log('Error restoring favorites: $e', name: 'FavoriteManager');
      return left(Failure(e.toString()));
    }
  }
}

final favoriteManagerProvider = Provider<FavoriteManager>((ref) {
  return FavoriteManager(
    local: ref.watch(favoriteCacheServiceProvider),
    remote: ref.watch(favoritesRepository),
  );
});
