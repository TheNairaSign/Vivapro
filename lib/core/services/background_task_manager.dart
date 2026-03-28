import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/services/notification_service.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:flutter/material.dart';

class BackgroundTaskManager {
  final NotificationService _notificationService = NotificationService();

  void initialize() {
    _notificationService.onActionReceived.listen(_handleNotificationResponse);
  }

  Future<void> _handleNotificationResponse(ReceivedAction action) async {
    final payload = action.payload?['data'];
    if (payload == null) return;

    try {
      final json = jsonDecode(payload);
      final call = ScheduleCall.fromJson(json);

      if (action.buttonKeyPressed == 'call_now' || action.buttonKeyPressed.isEmpty) {
        await _makePhoneCall(call);
      } else if (action.buttonKeyPressed == 'remind_later') {
        await _reschedule(call);
      }
    } catch (e) {
      debugPrint('Error handling notification response: $e');
    }
  }

  Future<void> _makePhoneCall(ScheduleCall call) async {
    if (call.contact.phones.isNotEmpty) {
      final phoneNumber = call.contact.phones.first.number;
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      // We don't check canLaunchUrl for 'tel' on some Android versions as it might match multiple apps
      // But it's safer to just try launching.
      try {
          await launchUrl(launchUri);
      } catch (e) {
          debugPrint('Could not launch dialer: $e');
      }
    } else {
        debugPrint('No phone number for contact');
    }
  }

  Future<void> _reschedule(ScheduleCall call) async {
    // Reschedule for 10 minutes later
    final currentScheduledDate = DateTime(
      call.date.year,
      call.date.month,
      call.date.day,
      call.time.hour,
      call.time.minute,
    );
    
    final newDate = currentScheduledDate.add(const Duration(minutes: 10));
    
    final newCall = call.copyWith(
      date: newDate,
      time: TimeOfDay(hour: newDate.hour, minute: newDate.minute),
    );
    
    await _notificationService.scheduleCallNotification(newCall);
  }
}
