import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/services/relationship_state_engine.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/repositories/favorite_repository.dart';

/// Represents a generated insight about a favorite contact
class ContactInsight {
  final FavoriteContact contact;
  final String message;
  final RelationshipState state;
  final int? daysSinceLastInteraction;
  final InsightPriority priority;

  ContactInsight({
    required this.contact,
    required this.message,
    required this.state,
    this.daysSinceLastInteraction,
    required this.priority,
  });
}

enum InsightPriority {
  high,    // Overdue or never contacted
  medium,  // Approaching overdue
  low,     // On track
}

/// Service that generates insights from favorite contacts
/// Follows the rules from core.md:
/// - Max 1 insight per contact at a time
/// - Max 2-3 insights on home screen
/// - No guilt-based language
class InsightGenerator {
  final FavoritesRepository _favoritesRepository;

  InsightGenerator(this._favoritesRepository);

  /// Generate insights for all favorite contacts
  /// Returns a stream of insights that updates when favorites change
  Stream<List<ContactInsight>> watchInsights() {
    return _favoritesRepository.watchFavorites().map((favorites) {
      return _generateInsights(favorites);
    });
  }

  /// Generate insights from a list of favorite contacts
  List<ContactInsight> _generateInsights(List<FavoriteContact> favorites) {
    final insights = <ContactInsight>[];

    for (final contact in favorites) {
      final state = RelationshipStateEngine.calculateState(contact);
      
      // Only generate insights for contacts that need attention
      if (_shouldGenerateInsight(state)) {
        final insight = _createInsight(contact, state);
        insights.add(insight);
      }
    }

    // Sort by priority and limit to top 3
    insights.sort((a, b) => _comparePriority(a.priority, b.priority));
    return insights.take(3).toList();
  }

  /// Determine if we should generate an insight for this state
  bool _shouldGenerateInsight(RelationshipState state) {
    return state == RelationshipState.overdue ||
           state == RelationshipState.neverContacted ||
           state == RelationshipState.approachingOverdue;
  }

  /// Create an insight for a contact
  ContactInsight _createInsight(
    FavoriteContact contact,
    RelationshipState state,
  ) {
    final message = RelationshipStateEngine.generateInsightMessage(contact);
    final daysSince = RelationshipStateEngine.getDaysSinceLastInteraction(contact);
    final priority = _getPriority(state);

    return ContactInsight(
      contact: contact,
      message: message,
      state: state,
      daysSinceLastInteraction: daysSince,
      priority: priority,
    );
  }

  /// Get priority level for a relationship state
  InsightPriority _getPriority(RelationshipState state) {
    switch (state) {
      case RelationshipState.overdue:
      case RelationshipState.neverContacted:
        return InsightPriority.high;
      case RelationshipState.approachingOverdue:
        return InsightPriority.medium;
      case RelationshipState.onTrack:
        return InsightPriority.low;
    }
  }

  /// Compare priorities for sorting (high priority first)
  int _comparePriority(InsightPriority a, InsightPriority b) {
    const priorityOrder = {
      InsightPriority.high: 0,
      InsightPriority.medium: 1,
      InsightPriority.low: 2,
    };
    return priorityOrder[a]!.compareTo(priorityOrder[b]!);
  }

  /// Get contacts that should be called today
  Stream<List<FavoriteContact>> watchPeopleToCallToday() {
    return _favoritesRepository.watchFavorites().map((favorites) {
      final peopleToCall = favorites.where((contact) {
        return RelationshipStateEngine.shouldCallToday(contact);
      }).toList();

      // Sort by priority
      return RelationshipStateEngine.sortByCallPriority(peopleToCall);
    });
  }
}

/// Provider for the insight generator
final insightGeneratorProvider = Provider<InsightGenerator>((ref) {
  final favoritesRepo = ref.watch(favoritesRepository);
  return InsightGenerator(favoritesRepo);
});

/// Provider for watching insights
final insightsStreamProvider = StreamProvider<List<ContactInsight>>((ref) {
  final generator = ref.watch(insightGeneratorProvider);
  return generator.watchInsights();
});

/// Provider for watching people to call today
final peopleToCallTodayProvider = StreamProvider<List<FavoriteContact>>((ref) {
  final generator = ref.watch(insightGeneratorProvider);
  return generator.watchPeopleToCallToday();
});
