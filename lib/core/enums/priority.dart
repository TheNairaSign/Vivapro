import 'dart:ui';

import 'package:flutter/material.dart';

enum CallPriority {
  high,
  medium,
  low,
}

Color priorityMap(CallPriority priority) {
  return switch (priority) {
    CallPriority.high => Colors.red,
    CallPriority.medium => Colors.orange,
    CallPriority.low => Colors.green,
  };
}
