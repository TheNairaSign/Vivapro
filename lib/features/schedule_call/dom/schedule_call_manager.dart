import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/core/services/notification_service.dart';
import 'package:vivapro/features/schedule_call/data/schedule_cache_service.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_dom.dart';
import 'package:vivapro/features/schedule_call/repositories/schedule_call_repository.dart';

import 'dart:developer' as developer;

class ScheduleCallManager extends ScheduleCallDom {
  final ScheduleCacheService local;
  final ScheduleCallRepository remote;
  final NotificationService notifications;

  ScheduleCallManager({
    required this.local,
    required this.remote,
    required this.notifications,
  });


  @override
  Future<Either<Failure, String>> scheduleCall(ScheduleCall call) async {
    final localResult = await local.scheduleCall(call);

    return localResult.fold((l) => left(l), (r) async {
      await notifications.scheduleCallNotification(call);
      return right(r);
    });
  }

  @override
  Stream<List<ScheduleCall>> watchScheduledCalls() => local.watchScheduledCalls();

  @override
  Future<Either<Failure, Unit>> rescheduleCall(ScheduleCall scheduleCall) async {
    try {
      final localResult = await local.rescheduleCall(scheduleCall);
      return localResult.fold((l) => left(l), (r) async {
        await notifications.scheduleCallNotification(scheduleCall);
        return right(unit);
      });
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSchedule(String scheduleId) async {
    try {
      final localResult = await local.deleteSchedule(scheduleId);
      return localResult.fold((l) => left(l), (r) async {
        await notifications.cancelNotification(scheduleId.hashCode);
        return right(unit);
      });
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

 // lib/features/schedule_call/dom/schedule_call_manager.dart

  // 1. Sync: Local -> Remote
  Future<Either<Failure, Unit>> syncAllToCloud() async {
    final localData = await local.getAllScheduledCalls();
    return localData.fold((l) => left(l), (calls) async {
      for (var call in calls) {
        if (call.id.isNotEmpty) {
          // Already synced once, perform update
          final updateResult = await remote.rescheduleCall(call);
          updateResult.fold(
            (failure) => developer.log('Sync Update failed for ${call.id}: $failure'),
            (_) => null,
          );
        } else {
          // First time syncing, perform creation and link ID
          final result = await remote.scheduleCall(call);
          result.fold(
            (failure) => developer.log('Sync Create failed for ${call.isarId}: $failure'),
            (cloudId) async {
              final updatedCall = call.copyWith(id: cloudId);
              updatedCall.isarId = call.isarId;
              await local.scheduleCall(updatedCall);
            },
          );
        }
      }
      return right(unit);
    });
  }

  // 2. Restore: Remote -> Local
  Future<Either<Failure, Unit>> restoreFromCloud() async {
    final remoteData = await remote.restoreAllScheduledCalls();
    return remoteData.fold((l) => left(l), (calls) async {
      // Clear local
      await local.clearCache();
      // Cancel all existing notifications
      await notifications.cancelAllNotifications();
      
      // Rehydrate local and recompute notifications
      for (var call in calls) {
        await local.scheduleCall(call);
        await notifications.scheduleCallNotification(call);
      }
      
      return right(unit);
    });
  }
}

final scheduleCallManagerProvider = Provider<ScheduleCallManager>((ref) {
  return ScheduleCallManager(
    local: ref.watch(scheduleCacheServiceProvider),
    remote: ref.watch(scheduleCallRepositoryProvider),
    notifications: NotificationService(),
  );
});
