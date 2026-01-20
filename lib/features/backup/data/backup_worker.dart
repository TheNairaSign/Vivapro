import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/core/services/notification_service.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';
import 'package:vivapro/features/schedule_call/repositories/schedule_call_repository.dart';

class BackupWorker {
  final ScheduleCallRepository remote;
  final ScheduleCallManager local;
  final NotificationService notifications;

  BackupWorker({
    required this.remote,
    required this.local,
    required this.notifications,
  });

  Future<Either<Failure, String>> backupAllScheduledCalls() async {
    final result = await local.syncAllToCloud();
    return result.fold(
      (l) => left(l),
      (r) => right('Backup successful'),
    );
  }

  Future<Either<Failure, Unit>> deleteSchedule(String scheduleId) async {
    try {
      final localResult = await local.deleteSchedule(scheduleId);
      return localResult.fold((l) => left(l), (r) async {
        await notifications.cancelNotification(scheduleId.hashCode);
        await remote.deleteSchedule(scheduleId);
        return right(unit);
      });
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, String>> restoreAllScheduledCalls() async {
    final result = await local.restoreFromCloud();
    return result.fold(
      (l) => left(l),
      (r) => right('Restore successful'),
    );
  }
}

final backupWorkerProvider = Provider<BackupWorker>((ref) {
  return BackupWorker(
    remote: ref.watch(scheduleCallRepositoryProvider),
    local: ref.watch(scheduleCallManagerProvider),
    notifications: NotificationService(),
  );
});