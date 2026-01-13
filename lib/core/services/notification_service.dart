import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // This runs in a separate isolate.
  // We can handle simple logic here or communicating with the main isolate if needed.
  // dealing with actions usually requires handling them when the app opens or via a service.
  debugPrint('notificationTapBackground: ${notificationResponse.actionId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<NotificationResponse> _notificationStreamController =
      StreamController<NotificationResponse>.broadcast();
  
  Stream<NotificationResponse> get onNotificationResponse => _notificationStreamController.stream;

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    try {
      final timeZoneResult = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = timeZoneResult.identifier;
      debugPrint('Detected timezone: $timeZoneName');
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint('Timezone set successfully to: ${tz.local.name}');
    } catch (e) {
      debugPrint('Could not set local timezone: $e');
      // Fallback to UTC or a default if necessary, though getting local usually works
      tz.setLocalLocation(tz.local); 
      debugPrint('Fallback timezone: ${tz.local.name}');
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');


    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          'call_reminder_category',
          actions: [
            DarwinNotificationAction.plain('call_now', 'Call Now'),
            DarwinNotificationAction.plain('remind_later', 'Remind Me Later'),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        )
      ],
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    final bool? initialized = await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        _notificationStreamController.add(notificationResponse);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    debugPrint('Notification Plugin Initialized: $initialized');

    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'scheduled_calls_channel',
      'Scheduled Calls',
      description: 'Notifications for scheduled calls',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    debugPrint('Android Notification Channel Created');
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? postNotificationsGranted =
          await androidImplementation?.requestNotificationsPermission();
      debugPrint('POST_NOTIFICATIONS granted: $postNotificationsGranted');

      final bool? exactAlarmGranted =
          await androidImplementation?.requestExactAlarmsPermission();
      debugPrint('EXACT_ALARM permission granted: $exactAlarmGranted');
    }
  }

  Future<void> scheduleCallNotification(ScheduleCall call) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      call.date.year,
      call.date.month,
      call.date.day,
      call.time.hour,
      call.time.minute,
    );

    debugPrint('Scheduling notification:');
    debugPrint('Current time (local): $now');
    debugPrint('Scheduled time (local): $scheduledDate');

    if (scheduledDate.isBefore(now)) {
      debugPrint('Skipping notification: Scheduled time is in the past.');
      return;
    }

    // Use a stable ID for the notification based on the call ID.
    // Ensure it's a positive integer, as some platforms might have issues with negative IDs.
    final notificationId = call.id.isEmpty ? call.hashCode : call.id.hashCode;

    // Verify types exist
    const androidAllowWhileIdle = AndroidScheduleMode.exactAllowWhileIdle;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId.abs(), 
      'Scheduled Call with ${call.contact.displayName}',
      call.note.isNotEmpty ? call.note : 'It\'s time for your call!',
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_calls_channel',
          'Scheduled Calls',
          channelDescription: 'Notifications for scheduled calls',
          importance: Importance.max,
          priority: Priority.high,
          actions: [
            const AndroidNotificationAction(
              'call_now',
              'Call Now',
              showsUserInterface: true,
            ),
            const AndroidNotificationAction(
              'remind_later',
              'Remind Me Later',
              showsUserInterface: false, // Background action
            ),
          ],
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: 'call_reminder_category',
        ),
      ),
      androidScheduleMode: androidAllowWhileIdle,
      payload: jsonEncode(call.toJson()), // Use jsonEncode for valid JSON
    ).then((_) {
      debugPrint('Notification scheduled successfully with ID: ${notificationId.abs()}');
    }).catchError((e) {
      debugPrint('Error scheduling notification: $e');
    });
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'scheduled_calls_channel',
      'Scheduled Calls',
      channelDescription: 'Notifications for scheduled calls',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'If you see this, notifications are working!',
      platformChannelSpecifics,
      payload: 'test',
    );
    debugPrint('Immediate test notification triggered');
  }
}
