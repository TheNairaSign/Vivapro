// lib/features/schedule_call/dom/schedule_call_manager.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/core/services/notification_handler.dart';
import 'package:vivapro/core/services/notification_service.dart';
import 'package:vivapro/features/schedule_call/data/schedule_cache_service.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_dom.dart';
import 'package:vivapro/features/schedule_call/repositories/schedule_call_repository.dart';

class ScheduleCallManager extends ScheduleCallDom {
  final ScheduleCacheService local;
  final ScheduleCallRepository remote; // Cloud
  final NotificationService notifications;

  ScheduleCallManager({
    required this.local,
    required this.remote,
    required this.notifications,
  });

  @override
  Future<Either<Failure, Unit>> scheduleCall(ScheduleCall call) async {
    // 1. SAVE TO SOURCE OF TRUTH (LOCAL)
    final localResult = await local.scheduleCall(call);

    return localResult.fold((l) => left(l), (r) async {
      // 2. TRIGGER NOTIFICATION
      await notifications.scheduleCallNotification(call);

      // 3. BACKGROUND SYNC (Don't 'await' this if you want it to be instant UI)
      // This follows your BACKUP.md rule: Local -> Cloud
      _syncToCloud(call);

      return right(unit);
    });
  }

  void _syncToCloud(ScheduleCall call) {
    // Check if backup is enabled in settings
    // If so, then push to remote
    remote.scheduleCall(call);

  }

  @override
  Stream<List<ScheduleCall>> watchScheduledCalls() => local.watchScheduledCalls();

  @override
  Future<Either<Failure, Unit>> rescheduleCall(ScheduleCall scheduleCall) async {
    try {
      await local.rescheduleCall(scheduleCall);
      await notifications.scheduleCallNotification(scheduleCall);
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSchedule(String scheduleId) async {
    try {
      await local.deleteSchedule(scheduleId);
      await notifications.cancelNotification(scheduleId.hashCode);
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

final scheduleCallManagerProvider = Provider<ScheduleCallManager>((ref) {
  return ScheduleCallManager(
    local: ref.watch(scheduleCacheServiceProvider),
    remote: ref.watch(scheduleCallRepositoryProvider),
    notifications: NotificationService(),
  );
});
