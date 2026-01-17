import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateFunctions {
  
  static String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, y').format(date);
  }

  static String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }
}
