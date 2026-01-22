import 'package:flutter/material.dart';


class AppTheme {

  static const accentLight = Color(0xFFF59E0B); // Amber 500
  static const accentDark = Color(0xFFFBBF24); // Amber 400

  static const accentLight2 = Color(0xFF14B8A6); // Teal 500
  static const accentDark2 = Color(0xFF5EEAD4); // Teal 300

  // Private color classes
  static const _lightColors = (
    primary: Color(0xffEA1E64),
    onPrimary: Colors.white,
    secondary: Color(0xffEA1E64),
    onSecondary: Colors.white,
    background: Color(0xFFF9FAFB),
    onBackground: Color(0xFF1F2937),
    surface: Colors.white,
    onSurface: Color(0xFF1F2937),
    error: Color(0xFFEF4444),
    onError: Colors.white,
    tertiary: accentLight,
  );

  static const _darkColors = (
    primary: Color(0xFF8B5CF6),
    onPrimary: Colors.white,
    secondary: Color(0xFF6366F1),
    onSecondary: Colors.white,
    background: Color(0xFF121212),
    onBackground: Color(0xFFF9FAFB),
    surface: Color(0xFF1F2937),
    onSurface: Color(0xFFF9FAFB),
    error: Color(0xFFF87171),
    onError: Colors.black,
    tertiary: accentDark,
  );

   static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: _darkColors.primary,
    fontFamily: 'DM Sans',
    colorScheme: ColorScheme.dark(
      primary: _darkColors.primary,
      secondary: _darkColors.primary,
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      tertiary: _darkColors.tertiary,
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFF0F0F0),
    primaryColor: _darkColors.primary,
    fontFamily: 'DM Sans',
    colorScheme: ColorScheme.light(
      primary: _darkColors.primary,
      secondary: _darkColors.secondary,
      background: Colors.white,
      // surface: Color(0xFFF0F0F0),
      surface: Colors.white,
      tertiary: _darkColors.tertiary,
    ),
  );
}