import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';

/// Service responsible for tracking interactions with favorite contacts
/// This is the primary method for updating lastInteractionAt timestamps
class InteractionTracker {
  final FavoriteCacheService _favoriteCache;

  InteractionTracker(
    this._favoriteCache,
  );

  Future<void> recordInteraction(String contactId) async {
    final now = DateTime.now();
    
    try {
      // Get the favorite and update it
      final favorite = await _favoriteCache.getFavoriteById(contactId);
      if (favorite != null) {
        final updatedFavorite = FavoriteContact(
          isarId: favorite.isarId,
          id: favorite.id,
          inAppUserId: favorite.inAppUserId,
          priority: favorite.priority,
          callFrequency: favorite.callFrequency,
          lastInteractionAt: now,
          createdAt: favorite.createdAt,
          updatedAt: now,
          contactDetailsJson: favorite.contactDetailsJson,
        );
        await _favoriteCache.addFavorite(updatedFavorite);
      }
    } catch (e) {
      print('Error recording interaction: $e');
    }
  }

  /// Record an interaction for a specific favorite contact object
  Future<void> recordInteractionForContact(FavoriteContact contact) async {
    await recordInteraction(contact.id);
  }

  /// Manually set the last interaction time (useful for importing call history)
  Future<void> setLastInteraction(
    String contactId,
    DateTime interactionTime,
  ) async {
    try {
       final favorite = await _favoriteCache.getFavoriteById(contactId);
      if (favorite != null) {
        final updatedFavorite = FavoriteContact(
          isarId: favorite.isarId,
          id: favorite.id,
          inAppUserId: favorite.inAppUserId,
          priority: favorite.priority,
          callFrequency: favorite.callFrequency,
          lastInteractionAt: interactionTime,
          createdAt: favorite.createdAt,
          updatedAt: DateTime.now(),
          contactDetailsJson: favorite.contactDetailsJson,
        );
        await _favoriteCache.addFavorite(updatedFavorite);
      }
    } catch (e) {
      print('Error setting last interaction: $e');
    }
  }

  /// Get the last interaction time for a contact
  Future<DateTime?> getLastInteraction(String contactId) async {
    try {
      final favorite = await _favoriteCache.getFavoriteById(contactId);
      return favorite?.lastInteractionAt;
    } catch (e) {
      print('Error getting last interaction: $e');
      return null;
    }
  }
}

/// Provider for the interaction tracker
final interactionTrackerProvider = Provider<InteractionTracker>((ref) {
  return InteractionTracker(
    ref.watch(favoriteCacheServiceProvider),
  );
});
