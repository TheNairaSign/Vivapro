import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/services/notification_service.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';

class NotificationHandler {
  final WidgetRef ref;
  
  NotificationHandler(this.ref);

  void listenToNotifications() {
    final notificationService = NotificationService();
    notificationService.onActionReceived.listen((ReceivedAction action) {
      _handleNotificationResponse(action);
    });
  }

  Future<void> _handleNotificationResponse(ReceivedAction action) async {
    final actionId = action.buttonKeyPressed;
    final payload = action.payload?['data'];
    
    if (payload == null) return;

    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      final scheduleCall = ScheduleCall.fromJson(data);
      
      // Default action (tapping the notification itself) or specific button
      if (actionId == 'call_now' || action.buttonKeyPressed.isEmpty) {
        await _handleCallNow(scheduleCall);
      } else if (actionId == 'remind_later') {
        await _handleRemindLater(scheduleCall);
      }
    } catch (e) {
      debugPrint('Error handling notification response: $e');
    }
  }

  Future<void> _handleCallNow(ScheduleCall call) async {
    final interactionTracker = ref.read(interactionTrackerProvider);
    final phoneNumber = call.contact.phones.isNotEmpty ? call.contact.phones.first.number : null;
    
    if (phoneNumber != null) {
      // Record the interaction
      await interactionTracker.recordInteraction(call.contact.id);
      
      // Open phone dialer
      final uri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  Future<void> _handleRemindLater(ScheduleCall call) async {

    final manager = ref.read(scheduleCallManagerProvider);
    
    // Reschedule for 30 minutes later
    final now = DateTime.now();
    final newScheduledTime = now.add(const Duration(minutes: 30));
    
    final updatedCall = call.copyWith(
      date: newScheduledTime,
      time: TimeOfDay(hour: newScheduledTime.hour, minute: newScheduledTime.minute),
    );

    await manager.rescheduleCall(updatedCall);
  }
}

