import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class DateFunctions {
  
  static String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, y').format(date);
  }

  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  static String formatDay(DateTime date, DateTime now) {
    if (isSameDay(now, date)) {
      return 'Today';
    } else if (isSameDay(now.add(const Duration(days: 1)), date)) {
      return 'Tomorrow';
    } else if (isSameDay(now.subtract(const Duration(days: 1)), date)) {
      return 'Yesterday';
    } else {
      return DateFormat('EEE, MMM d').format(date)+date.daySuffix;
    }
  }
}

extension DateTimeOrdinal on DateTime {
  /// Returns st, nd, rd, th
  String get daySuffix {
    final day = this.day;

    if (day >= 11 && day <= 13) {
      return 'th';
    }

    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Returns day with suffix (e.g. 21st)
  String get dayWithSuffix => '$day$daySuffix';
}

