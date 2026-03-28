import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vivapro/core/services/background_task_manager.dart';
import 'package:vivapro/core/services/notification_service.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();

  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  final backgroundTaskManager = BackgroundTaskManager();
  backgroundTaskManager.initialize();

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
