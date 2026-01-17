import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/services/notification_service.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/repositories/schedule_call_repository.dart';

class NotificationHandler {
  final WidgetRef ref;
  
  NotificationHandler(this.ref);

  void listenToNotifications() {
    final notificationService = NotificationService();
    notificationService.onNotificationResponse.listen((response) {
      _handleNotificationResponse(response);
    });
  }

  Future<void> _handleNotificationResponse(dynamic response) async {
    final actionId = response.actionId;
    final payload = response.payload;
    
    if (payload == null || payload == 'test') return;

    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      final scheduleCall = ScheduleCall.fromJson(data);
      
      if (actionId == 'call_now') {
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
    final repository = ref.read(scheduleCallRepositoryProvider);
    
    // Reschedule for 30 minutes later
    final now = DateTime.now();
    final newScheduledTime = now.add(const Duration(minutes: 30));
    
    final updatedCall = call.copyWith(
      date: newScheduledTime,
      time: TimeOfDay(hour: newScheduledTime.hour, minute: newScheduledTime.minute),
    );

    await repository.rescheduleCall(updatedCall);
  }
}

final notificationHandlerProvider = Provider.family<NotificationHandler, WidgetRef>((ref, widgetRef) {
  return NotificationHandler(widgetRef);
});
