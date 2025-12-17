import 'package:flutter/material.dart';

class GlobalColors {
  // Modern/Fresh Palette
  static const freshPink = Color(0xFFFF6B8B);
  static const softCream = Color(0xFFFFF7F0); // Warmer, fresher background
  static const appBackground = Color(0xFFFBF8F1); // Beige background from image
  static const navBarBlack = Color(0xFF1E1E1E); // Dark background for nav bar
  static const forestGreen = Color(0xFF2D5A46);
  static const brightGreen = Color(0xFFAED581);
  static const periwinkle = Color(0xFF9FA8DA);
  static const peach = Color(0xFFFFAB91);
  static const charcoal = Color(0xFF2D2D2D);
  
  // Keep some legacy or map them
  static final bitterSweet = freshPink; 
  static final current = periwinkle;
  static final darkPurple = const Color(0xFF1E1C30); // Keep for dark mode depth
  static final yellow = const Color(0xFFFFD54F); // More pastel yellow
  static final teal = const Color(0xFF80CBC4);
  static final tealDark = forestGreen;

  static Color? containerThemeColor(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF2C2C2C) : Colors.white;
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
    return [
      BoxShadow(
        color: const Color(0xFF1A1A2C).withValues(alpha: 0.08), // Softer, colored shadow
        spreadRadius: 0,
        blurRadius: 20, // Much softer blur
        offset: const Offset(0, 8),
      ),
    ];
  }
}
