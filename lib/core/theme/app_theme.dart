import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
 static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: const Color(0xFF3D7BFF),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3D7BFF),
      secondary: Color(0xFF3D7BFF),
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFF0F0F0),
    primaryColor: const Color(0xFF3D7BFF),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3D7BFF),
      secondary: Color(0xFF3D7BFF),
      background: Colors.white,
      surface: Colors.white,
    ),
  );
}
