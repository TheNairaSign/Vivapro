import 'package:flutter/material.dart';

enum CallPriority { high, medium, low }

Color priorityColorMap(CallPriority priority) {
  return switch (priority) {
    CallPriority.high => Colors.red,
    CallPriority.medium => Colors.orange,
    CallPriority.low => Colors.green,
  };
}
