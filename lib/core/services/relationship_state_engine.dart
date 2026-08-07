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
  /// Days a weekday-anchored checkup (weekly/custom) stays "overdue" after being
  /// missed before it rolls over to its next scheduled occurrence.
  static const int _weeklyGraceDays = 2;

  /// Days a month-day-anchored checkup (monthly/custom) stays "overdue" after being
  /// missed before it rolls over to its next scheduled occurrence.
  static const int _monthlyGraceDays = 5;

  /// How many days out a not-yet-due upcoming checkup counts as "approaching".
  static const int _approachingWindowDays = 1;

  static bool _isAnchoredFrequency(CallFrequency frequency) =>
      frequency == CallFrequency.weekly ||
      frequency == CallFrequency.monthly ||
      frequency == CallFrequency.custom;

  /// Calculate the relationship state for a favorite contact
  static RelationshipState calculateState(FavoriteContact contact) {
    final lastInteraction = contact.lastInteractionAt;

    // If never contacted, return special state
    if (lastInteraction == null) {
      return RelationshipState.neverContacted;
    }

    if (_isAnchoredFrequency(contact.callFrequency)) {
      return _calculateAnchoredState(contact);
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

  /// Calendar-anchored state calculation for weekly/monthly/custom contacts.
  /// Instead of a rolling "days since last call" window, this compares against
  /// the contact's specific chosen weekday(s)/date(s).
  static RelationshipState _calculateAnchoredState(FavoriteContact contact) {
    final lastInteraction = contact.lastInteractionAt;
    if (lastInteraction == null) return RelationshipState.neverContacted;

    final today = _dateOnly(DateTime.now());
    final occurrences = _buildOccurrences(contact, today);
    if (occurrences.isEmpty) return RelationshipState.onTrack;

    // The governing occurrence is whichever selected day was most recently due.
    occurrences.sort((a, b) => b.mostRecent.compareTo(a.mostRecent));
    final due = occurrences.first;
    final nextDate = occurrences.map((o) => o.next).reduce((a, b) => a.isBefore(b) ? a : b);
    final daysUntilNext = nextDate.difference(today).inDays;

    final calledSinceDue = !lastInteraction.isBefore(due.mostRecent);
    if (calledSinceDue) {
      return daysUntilNext <= _approachingWindowDays
          ? RelationshipState.approachingOverdue
          : RelationshipState.onTrack;
    }

    final daysSinceDue = today.difference(due.mostRecent).inDays;
    if (daysSinceDue <= due.graceDays) {
      return RelationshipState.overdue;
    }

    // Past the grace window: rolled over to the next cycle rather than staying
    // overdue forever, so missed checkups don't pile up in "People to Call Today".
    return daysUntilNext <= _approachingWindowDays
        ? RelationshipState.approachingOverdue
        : RelationshipState.onTrack;
  }

  static DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  /// Best available "creation-like" anchor for a contact, used both as the
  /// legacy default checkup day and as the fallback when computing occurrences.
  static DateTime _anchorDate(FavoriteContact contact) {
    return contact.createdAt ?? contact.updatedAt ?? DateTime.now();
  }

  /// Effective weekday(s) to check up on: the contact's saved selection, or a
  /// single default derived from [_anchorDate] if none was ever saved.
  static List<int> effectiveWeekdays(FavoriteContact contact) {
    final stored = contact.checkupWeekdays;
    if (stored != null && stored.isNotEmpty) return stored;
    return [_anchorDate(contact).weekday];
  }

  /// Effective day(s) of month to check up on: the contact's saved selection,
  /// or a single default derived from [_anchorDate] if none was ever saved.
  static List<int> effectiveMonthDays(FavoriteContact contact) {
    final stored = contact.checkupMonthDays;
    if (stored != null && stored.isNotEmpty) return stored;
    return [_anchorDate(contact).day];
  }

  /// Which weekday/month-day sets actually govern this contact's schedule.
  static (List<int> weekdays, List<int> monthDays) _activeDaySets(FavoriteContact contact) {
    switch (contact.callFrequency) {
      case CallFrequency.weekly:
        return (effectiveWeekdays(contact), const <int>[]);
      case CallFrequency.monthly:
        return (const <int>[], effectiveMonthDays(contact));
      case CallFrequency.custom:
        final weekdays = contact.checkupWeekdays ?? const <int>[];
        final monthDays = contact.checkupMonthDays ?? const <int>[];
        if (weekdays.isEmpty && monthDays.isEmpty) {
          // Custom with nothing explicitly configured still needs a schedule.
          return (effectiveWeekdays(contact), const <int>[]);
        }
        return (weekdays, monthDays);
      case CallFrequency.daily:
      case CallFrequency.yearly:
        return (const <int>[], const <int>[]);
    }
  }

  static List<_ScheduledOccurrence> _buildOccurrences(FavoriteContact contact, DateTime today) {
    final (weekdays, monthDays) = _activeDaySets(contact);
    return [
      for (final weekday in weekdays)
        _ScheduledOccurrence(
          mostRecent: _mostRecentWeekdayOccurrence(weekday, today),
          next: _nextWeekdayOccurrence(weekday, today),
          graceDays: _weeklyGraceDays,
        ),
      for (final day in monthDays)
        _ScheduledOccurrence(
          mostRecent: _mostRecentMonthOccurrence(day, today),
          next: _nextMonthOccurrence(day, today),
          graceDays: _monthlyGraceDays,
        ),
    ];
  }

  static DateTime _mostRecentWeekdayOccurrence(int weekday, DateTime today) {
    final diff = (today.weekday - weekday) % 7;
    return today.subtract(Duration(days: diff));
  }

  static DateTime _nextWeekdayOccurrence(int weekday, DateTime today) {
    final diff = (weekday - today.weekday) % 7;
    return today.add(Duration(days: diff == 0 ? 7 : diff));
  }

  /// Clamps a day-of-month (e.g. 31) to the last real day of that month (e.g. 30 in April).
  static DateTime _clampedMonthDate(int year, int month, int day) {
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDayOfMonth ? lastDayOfMonth : day);
  }

  static DateTime _mostRecentMonthOccurrence(int day, DateTime today) {
    final thisMonth = _clampedMonthDate(today.year, today.month, day);
    if (!thisMonth.isAfter(today)) return thisMonth;
    return _clampedMonthDate(today.year, today.month - 1, day);
  }

  static DateTime _nextMonthOccurrence(int day, DateTime today) {
    final thisMonth = _clampedMonthDate(today.year, today.month, day);
    if (thisMonth.isAfter(today)) return thisMonth;
    return _clampedMonthDate(today.year, today.month + 1, day);
  }

  static DateTime _anchoredNextCallDate(FavoriteContact contact) {
    final today = _dateOnly(DateTime.now());
    final occurrences = _buildOccurrences(contact, today);
    if (occurrences.isEmpty) return today;

    occurrences.sort((a, b) => b.mostRecent.compareTo(a.mostRecent));
    final due = occurrences.first;
    final lastInteraction = contact.lastInteractionAt;
    final calledSinceDue = lastInteraction != null && !lastInteraction.isBefore(due.mostRecent);

    if (!calledSinceDue) return due.mostRecent;
    return occurrences.map((o) => o.next).reduce((a, b) => a.isBefore(b) ? a : b);
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

    if (_isAnchoredFrequency(contact.callFrequency)) {
      final today = _dateOnly(DateTime.now());
      return _anchoredNextCallDate(contact).difference(today).inDays;
    }

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
          if (daysSince == 1) {
            return "You haven't spoken to $name in a day";
          }
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

  /// Get the next recommended call date based on frequency and last interaction
  static DateTime getNextCallDate(FavoriteContact contact) {
    if (_isAnchoredFrequency(contact.callFrequency)) {
      return _anchoredNextCallDate(contact);
    }

    // If never contacted, it's due since creation or now
    final lastInteraction = contact.lastInteractionAt ?? contact.createdAt ?? DateTime.now();
    final targetDays = _getTargetDaysForFrequency(contact.callFrequency);

    return lastInteraction.add(Duration(days: targetDays));
  }
}

/// A single scheduled checkup occurrence: the most recent past date it fell on,
/// the next future date it will fall on, and how many days of "overdue" grace
/// it gets after being missed before rolling over to that next date.
class _ScheduledOccurrence {
  final DateTime mostRecent;
  final DateTime next;
  final int graceDays;

  _ScheduledOccurrence({
    required this.mostRecent,
    required this.next,
    required this.graceDays,
  });
}
