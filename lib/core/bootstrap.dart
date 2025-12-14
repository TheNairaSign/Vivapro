import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivapro/firebase_options.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);  
}

void applyModernStatusBarStyle(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      // Transparent status bar (recommended for modern apps with edge-to-edge)
      statusBarColor: theme.scaffoldBackgroundColor,

      // Icons color based on theme
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,

      // Optional: Use system accent color on Android 12+ (Material You)
      systemStatusBarContrastEnforced: false, // Needed for custom colors
    ),
  );
}
