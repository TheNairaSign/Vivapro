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
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('Could not set local timezone: $e');
      // Fallback to UTC or a default if necessary, though getting local usually works
      tz.setLocalLocation(tz.local); 
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

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        _notificationStreamController.add(notificationResponse);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
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
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleCallNotification(ScheduleCall call) async {
    final scheduledDate = tz.TZDateTime.from(
      DateTime(
        call.date.year,
        call.date.month,
        call.date.day,
        call.time.hour,
        call.time.minute,
      ),
      tz.local,
    );

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      // Don't schedule in the past
      return;
    }

    // Verify types exist
    const androidAllowWhileIdle = AndroidScheduleMode.exactAllowWhileIdle;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      call.hashCode, // Use hashcode as ID (or convert string ID to int)
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
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
