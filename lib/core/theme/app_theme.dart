import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private color classes
  static const _lightColors = (
    primary: Color(0xFF22C55E),
    onPrimary: Colors.white,
    secondary: Color(0xFF10B981),
    onSecondary: Colors.white,
    background: Color(0xFFF9FAFB),
    onBackground: Color(0xFF1F2937),
    surface: Colors.white,
    onSurface: Color(0xFF1F2937),
    error: Color(0xFFEF4444),
    onError: Colors.white,
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
  );
  /*

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _lightColors.primary,
    scaffoldBackgroundColor: _lightColors.background, // Use _lightColors.background
    textTheme: GoogleFonts.manropeTextTheme(ThemeData.light().textTheme),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: _lightColors.primary,
      onPrimary: _lightColors.onPrimary,
      secondary: _lightColors.secondary,
      onSecondary: _lightColors.onSecondary,
      background: _lightColors.background,
      onBackground: _lightColors.onBackground,
      surface: _lightColors.surface,
      onSurface: _lightColors.onSurface,
      error: _lightColors.error,
      onError: _lightColors.onError,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: _lightColors.onBackground),
      titleTextStyle: GoogleFonts.manrope(
        color: _lightColors.onBackground,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: _darkColors.primary,
    scaffoldBackgroundColor: _darkColors.background,
    textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: _darkColors.primary,
      onPrimary: _darkColors.onPrimary,
      secondary: _darkColors.secondary,
      onSecondary: _darkColors.onSecondary,
      background: _darkColors.background,
      onBackground: _darkColors.onBackground,
      surface: _darkColors.surface,
      onSurface: _darkColors.onSurface,
      error: _darkColors.error,
      onError: _darkColors.onError,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: _darkColors.onBackground),
      titleTextStyle: GoogleFonts.manrope(
        color: _darkColors.onBackground,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  */

   static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: _darkColors.primary,
    textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.dark(
      primary: _darkColors.primary,
      secondary: _darkColors.primary,
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFF0F0F0),
    primaryColor: _darkColors.primary,
    textTheme: GoogleFonts.dmSansTextTheme(ThemeData.light().textTheme),
    colorScheme: ColorScheme.light(
      primary: _darkColors.primary,
      secondary: _darkColors.secondary,
      background: Colors.white,
      // surface: Color(0xFFF0F0F0),
      surface: Colors.white
    ),
  );
}