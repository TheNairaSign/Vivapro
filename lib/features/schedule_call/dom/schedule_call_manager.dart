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

  // 1. Sync: Local -> Remote
  Future<Either<Failure, Unit>> syncAllToCloud() async {
    try {
      final localDataResult = await local.getAllScheduledCalls();
      return await localDataResult.fold((l) => left(l), (localCalls) async {
        final remoteCallsResult = await remote.restoreAllScheduledCalls();
        return await remoteCallsResult.fold((l) => left(l), (remoteCalls) async {
          final remoteMap = {for (var c in remoteCalls) c.id: c};
          final List<ScheduleCall> localUpdates = [];

          for (var localCall in localCalls) {
            final remoteCall = remoteMap[localCall.id];

            if (localCall.id.isEmpty) {
              // Create new and link ID
              final result = await remote.scheduleCall(localCall);
              await result.fold(
                (failure) async => developer.log('Sync Create failed: $failure'),
                (cloudId) async {
                  final updatedCall = localCall.copyWith(id: cloudId);
                  updatedCall.isarId = localCall.isarId;
                  localUpdates.add(updatedCall);
                },
              );
            } else if (remoteCall == null || localCall.updatedAt.isAfter(remoteCall.updatedAt)) {
              // Update remote (Last Write Wins)
              await remote.rescheduleCall(localCall);
            }
          }

          if (localUpdates.isNotEmpty) {
            await local.cacheSchedules(localUpdates);
          }
          
          return right(unit);
        });
      });
    } catch (e) {
      developer.log('Error syncing scheduled calls: $e', name: 'SC Manager');
      return left(Failure(e.toString()));
    }
  }

  // 2. Restore: Remote -> Local
  Future<Either<Failure, Unit>> restoreFromCloud() async {
    final remoteData = await remote.restoreAllScheduledCalls();
    return remoteData.fold((l) => left(l), (calls) async {
      // Cancel all existing notifications
      await notifications.cancelAllNotifications();
      
      // Atomic Replace local
      await local.replaceCache(calls);

      // Re-schedule notifications
      for (var call in calls) {
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
