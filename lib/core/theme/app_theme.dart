import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class AppTheme {

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: GlobalColors.appBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: GlobalColors.freshPink,
      surface: GlobalColors.appBackground,
      primary: GlobalColors.freshPink,
      secondary: GlobalColors.brightGreen,
      tertiary: GlobalColors.periwinkle,
    ),
    textTheme: GoogleFonts.dmSansTextTheme().apply(
      bodyColor: GlobalColors.charcoal,
      displayColor: GlobalColors.charcoal,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: GlobalColors.navBarBlack,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: GlobalColors.charcoal),
      titleTextStyle: TextStyle(
        color: GlobalColors.charcoal,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'DMSans',
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GlobalColors.freshPink,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: GlobalColors.freshPink, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: GlobalColors.darkPurple,
    colorScheme: ColorScheme.fromSeed(
      seedColor: GlobalColors.periwinkle,
      brightness: Brightness.dark,
      surface: const Color(0xFF2C2C3E), // Slightly lighter than bg
    ),
    textTheme: GoogleFonts.dmSansTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2C2C3E),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GlobalColors.periwinkle,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C3E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    ),
  );
}