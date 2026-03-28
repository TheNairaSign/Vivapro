import 'dart:convert';
import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:vivapro/features/events/data/calendar_event.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final StreamController<ReceivedAction> _actionStreamController = StreamController<ReceivedAction>.broadcast();
  
  Stream<ReceivedAction> get onActionReceived => _actionStreamController.stream;

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelKey: 'scheduled_calls_channel',
          channelName: 'Scheduled Calls',
          channelDescription: 'Notifications for scheduled calls',
          defaultColor: const Color(0xFF9D50BB),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
        NotificationChannel(
          channelKey: 'scheduled_events_channel',
          channelName: 'Scheduled Events',
          channelDescription: 'Notifications for scheduled events',
          defaultColor: const Color(0xFF9D50BB),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
        ),
      ],
      debug: true,
    );

    // Set up listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationService.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationService.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationService.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationService.onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    debugPrint('Notification created: ${receivedNotification.id}');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    debugPrint('Notification displayed: ${receivedNotification.id}');
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint('Notification dismissed: ${receivedAction.id}');
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    debugPrint('Notification action received: ${receivedAction.buttonKeyPressed}');
    NotificationService()._actionStreamController.add(receivedAction);
  }

  Future<void> requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> scheduleCallNotification(ScheduleCall call) async {
    final scheduledDate = DateTime(
      call.date.year,
      call.date.month,
      call.date.day,
      call.time.hour,
      call.time.minute,
    );

    if (scheduledDate.isBefore(DateTime.now())) {
      debugPrint('Skipping notification: Scheduled time is in the past.');
      return;
    }

    final notificationId = call.id.isEmpty ? call.hashCode : call.id.hashCode;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId.abs(),
        channelKey: 'scheduled_calls_channel',
        title: 'Scheduled Call with ${call.contact.displayName}',
        body: call.note.isNotEmpty ? call.note : "It's time for your call!",
        notificationLayout: NotificationLayout.Default,
        payload: {
          'data': jsonEncode(call.toJson()),
        },
        // HIDE notification in foreground as requested
        displayOnForeground: false,
        displayOnBackground: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'call_now',
          label: 'Call Now',
          actionType: ActionType.Default,
        ),
        NotificationActionButton(
          key: 'remind_later',
          label: 'Remind Me Later',
          actionType: ActionType.SilentBackgroundAction,
        ),
      ],
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
    );
    debugPrint('Call notification scheduled for $scheduledDate');
  }

  Future<void> scheduleCalendarEventNotification(CalendarEvent event) async {
    final scheduledDate = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
      event.timeHour,
      event.timeMinute,
    );

    if (scheduledDate.isBefore(DateTime.now())) {
      debugPrint('Skipping notification: Scheduled time is in the past.');
      return;
    }

    final notificationId = event.id.isEmpty ? event.hashCode : event.id.hashCode;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId.abs(),
        channelKey: 'scheduled_events_channel',
        title: event.title,
        body: event.description.isNotEmpty ? event.description : 'Your scheduled event is starting now!',
        notificationLayout: NotificationLayout.Default,
        payload: {
          'data': jsonEncode(event.toJson()),
        },
        displayOnForeground: false, // HIDE in foreground
        displayOnBackground: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'view_event',
          label: 'View Event',
          actionType: ActionType.Default,
        ),
      ],
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
    );
    debugPrint('Event notification scheduled for $scheduledDate');
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  Future<void> showTestNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'scheduled_calls_channel',
        title: 'Test Notification',
        body: 'If you see this, notifications are working!',
        displayOnForeground: false, // HIDE in foreground
      ),
    );
  }
}
