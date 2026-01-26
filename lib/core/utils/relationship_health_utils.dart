import 'package:flutter/material.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';

class RelationshipHealthUtils {
  
  static int calculateHealthForPeriod(
    List<FavoriteContact> favorites,
    List<ActivityLog> activities,
    String filter,
  ) {
    if (favorites.isEmpty) return 100;

    final now = DateTime.now();
    int periodDays = 7;
    if (filter == 'Daily') periodDays = 1;
    if (filter == 'Monthly') periodDays = 30;

    final startDate = now.subtract(Duration(days: periodDays));

    double totalHealthScore = 0;

    for (final favorite in favorites) {
      final favoriteActivities = activities
          .where((a) => a.contactId == favorite.id && a.timestamp.isAfter(startDate))
          .toList();

      final targetDays = getTargetDaysForFrequency(favorite.callFrequency);
      final expectedInteractions = (periodDays / targetDays).clamp(1.0, double.infinity);

      final actualInteractions = favoriteActivities.length;

      double favoriteScore = (actualInteractions / expectedInteractions).clamp(0.0, 1.0);

      totalHealthScore += favoriteScore;
    }

    return ((totalHealthScore / favorites.length) * 100).round();
  }

  static int getTargetDaysForFrequency(CallFrequency frequency) {
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
        return 7;
    }
  }

  static Color getHealthColor(BuildContext context, int health) {
    if (health >= 90) return Theme.of(context).colorScheme.primary;
    if (health >= 70) return const Color(0xFF4CAF50);
    if (health >= 50) return const Color(0xFFFFC107);
    if (health >= 30) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

}