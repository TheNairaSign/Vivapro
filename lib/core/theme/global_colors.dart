import 'package:flutter/material.dart';

class GlobalColors {
  static final bitterSweet = const Color(0xFFff7364);
  static final current = const Color(0xFF3434ad);
  static final darkPurple = const Color(0xFF1e1c30);
  static final yellow = const Color(0xFFFFD43B);
  static final teal = const Color(0xFFC3FAE8);
  static final tealDark = const Color(0xFF37B287);

  static Color? containerThemeColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.grey[900]!.withValues(alpha: .5) : Colors.white;
  }

  static Color? containerColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.grey[900] : Colors.white;
  }

  static Color? textThemeColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.white : Colors.black;
  }

  static List<BoxShadow> boxShadow(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return [
      BoxShadow(
        color: isDark ? Colors.transparent : Colors.grey.withValues(alpha: 0.1),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 5),
      ),
    ];
  }
}
