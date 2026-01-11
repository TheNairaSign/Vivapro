import 'package:flutter/material.dart';

enum CallFrequency { daily, weekly, monthly, yearly, custom }

Color callFrequencyColor(CallFrequency frequency) {
  switch (frequency) {
    case CallFrequency.daily:
      return Colors.blue;
    case CallFrequency.weekly:
      return Colors.green;
    case CallFrequency.monthly:
      return Colors.yellow;
    case CallFrequency.yearly:
      return Colors.red;
    case CallFrequency.custom:
      return Colors.purple;
  }
}
