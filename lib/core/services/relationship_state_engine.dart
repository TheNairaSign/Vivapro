import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';

/// Represents the current state of a relationship based on interaction frequency
enum RelationshipState {
  onTrack,           // User is maintaining the desired frequency
  approachingOverdue, // Getting close to being overdue
  overdue,           // Past the desired frequency
  neverContacted,    // No interaction recorded yet
}

/// Extension to get days until overdue/days overdue
extension RelationshipStateData on RelationshipState {
  String get displayName {
    switch (this) {
      case RelationshipState.onTrack:
        return 'On Track';
      case RelationshipState.approachingOverdue:
        return 'Approaching Overdue';
      case RelationshipState.overdue:
        return 'Overdue';
      case RelationshipState.neverContacted:
        return 'Never Contacted';
    }
  }
}

/// Core engine that calculates relationship states for favorite contacts
/// This is the heart of the favorites-driven system
class RelationshipStateEngine {
  /// Calculate the relationship state for a favorite contact
  static RelationshipState calculateState(FavoriteContact contact) {
    final lastInteraction = contact.lastInteractionAt;
    
    // If never contacted, return special state
    if (lastInteraction == null) {
      return RelationshipState.neverContacted;
    }
    
    final now = DateTime.now();
    final daysSinceLastInteraction = now.difference(lastInteraction).inDays;
    final targetDays = _getTargetDaysForFrequency(contact.callFrequency);
    
    // Calculate thresholds
    final approachingThreshold = (targetDays * 0.8).round(); // 80% of target
    
    if (daysSinceLastInteraction >= targetDays) {
      return RelationshipState.overdue;
    } else if (daysSinceLastInteraction >= approachingThreshold) {
      return RelationshipState.approachingOverdue;
    } else {
      return RelationshipState.onTrack;
    }
  }
  
  /// Get days since last interaction (or null if never contacted)
  static int? getDaysSinceLastInteraction(FavoriteContact contact) {
    if (contact.lastInteractionAt == null) return null;
    return DateTime.now().difference(contact.lastInteractionAt!).inDays;
  }
  
  /// Get days until overdue (negative if already overdue)
  static int getDaysUntilOverdue(FavoriteContact contact) {
    final lastInteraction = contact.lastInteractionAt;
    if (lastInteraction == null) return 0; // Already overdue if never contacted
    
    final daysSinceLastInteraction = DateTime.now().difference(lastInteraction).inDays;
    final targetDays = _getTargetDaysForFrequency(contact.callFrequency);
    
    return targetDays - daysSinceLastInteraction;
  }
  
  /// Check if contact should appear in "People to Call Today"
  static bool shouldCallToday(FavoriteContact contact) {
    final state = calculateState(contact);
    return state == RelationshipState.overdue || 
           state == RelationshipState.neverContacted ||
           state == RelationshipState.approachingOverdue;
  }
  
  /// Get target days for a given call frequency
  static int _getTargetDaysForFrequency(CallFrequency frequency) {
    switch (frequency) {
      case CallFrequency.daily:
        return 1;
      case CallFrequency.weekly:
        return 7;
      case CallFrequency.monthly:
        return 30;
      case CallFrequency.yearly:
        return 365;
      case CallFrequency.custom:
        return 7; // Default to weekly for custom
    }
  }
  
  /// Generate a human-readable insight message for a contact
  static String generateInsightMessage(FavoriteContact contact) {
    final state = calculateState(contact);
    final name = contact.contactDetails.displayName;
    final daysSince = getDaysSinceLastInteraction(contact);
    
    switch (state) {
      case RelationshipState.neverContacted:
        return "You haven't called $name yet";
      case RelationshipState.overdue:
        if (daysSince != null) {
          return "You haven't spoken to $name in $daysSince days";
        }
        return "Time to reconnect with $name";
      case RelationshipState.approachingOverdue:
        final daysUntil = getDaysUntilOverdue(contact);
        if (daysUntil > 0) {
          return "Call $name in the next $daysUntil days";
        }
        return "Consider calling $name soon";
      case RelationshipState.onTrack:
        return "You're staying connected with $name";
    }
  }
  
  /// Sort contacts by priority for "People to Call Today"
  /// Priority order: Overdue (by days) > Never Contacted > Approaching Overdue
  static List<FavoriteContact> sortByCallPriority(List<FavoriteContact> contacts) {
    final sorted = List<FavoriteContact>.from(contacts);
    
    sorted.sort((a, b) {
      final stateA = calculateState(a);
      final stateB = calculateState(b);
      
      // First, sort by state priority
      final statePriorityA = _getStatePriority(stateA);
      final statePriorityB = _getStatePriority(stateB);
      
      if (statePriorityA != statePriorityB) {
        return statePriorityA.compareTo(statePriorityB);
      }
      
      // Within same state, sort by days since last interaction (descending)
      final daysA = getDaysSinceLastInteraction(a) ?? 999999;
      final daysB = getDaysSinceLastInteraction(b) ?? 999999;
      
      return daysB.compareTo(daysA);
    });
    
    return sorted;
  }
  
  static int _getStatePriority(RelationshipState state) {
    switch (state) {
      case RelationshipState.overdue:
        return 0; // Highest priority
      case RelationshipState.neverContacted:
        return 1;
      case RelationshipState.approachingOverdue:
        return 2;
      case RelationshipState.onTrack:
        return 3; // Lowest priority
    }
  }
}
