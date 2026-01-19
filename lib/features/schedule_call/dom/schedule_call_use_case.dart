import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/schedule_call/data/schedule_cache_service.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';
import 'package:vivapro/features/schedule_call/repositories/schedule_call_repository.dart';

class ScheduleCallUseCase {
  final ScheduleCallManager manager;

  ScheduleCallUseCase(this.manager);

  Future<bool> setReminder(ContactInsight insight) async {
      final now = DateTime.now();
      final tomorrow = DateTime(
        now.year,
        now.month,
        now.day + 1,
        10,
        0,
      );

      return await setContactReminder(
        insight.contact, 
        tomorrow,
        note: 'Follow up from insight: ${insight.message}',
      );
    }

    Future<bool> setContactReminder(
      FavoriteContact contact, 
      DateTime scheduledDateTime, 
      {String? note}
    ) async {
      final call = ScheduleCall.create(
        id: '',
        contact: contact.contactDetails,
        date: scheduledDateTime,
        time: TimeOfDay(hour: scheduledDateTime.hour, minute: scheduledDateTime.minute),
        note: note ?? 'Reminder for ${contact.contactDetails.displayName}',
      );

      final result = await manager.scheduleCall(call);

      return result.fold(
        (failure) => false,
        (r) => true,
      );
    }
}

final scheduleCallUseCase = Provider<ScheduleCallUseCase>((ref) {
  final scheduleManager = ref.watch(scheduleCallManagerProvider);
  return ScheduleCallUseCase(scheduleManager);
});