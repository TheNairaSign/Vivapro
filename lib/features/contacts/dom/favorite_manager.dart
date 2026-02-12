import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';

class FavoriteManager {
  final FavoriteCacheService local;

  FavoriteManager({required this.local});
}

final favoriteManagerProvider = Provider<FavoriteManager>((ref) {
  return FavoriteManager(local: ref.watch(favoriteCacheServiceProvider));
});
