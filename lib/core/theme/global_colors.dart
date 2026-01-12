import 'package:flutter/material.dart';

class GlobalColors {
  // Modern/Fresh Palette
  static const freshPink = Color(0xFFFF6B8B);
  static const onLightSurface = Color(0xffeeeef0);
  static const goldBackground = Color(0xFFFFF9E6);
  static const goldBorder = Color(0xFFFFF5D6);

  // Added for NewChatScreen compatibility
  static const yellow = Color(0xFFFFD700);
  static const darkPurple = Color(0xFF2A005E);

  static Color? containerThemeColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2C2C2C) : Colors.white;
  }

  static Color? containerColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF1C2029) : Colors.white;
  }

  static Color? textThemeColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black;
  }

  static List<BoxShadow> boxShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ];
  }
}
