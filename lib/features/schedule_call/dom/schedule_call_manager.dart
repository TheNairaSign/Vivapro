import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/core/services/notification_service.dart';
import 'package:vivapro/features/schedule_call/data/schedule_cache_service.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_dom.dart';

class ScheduleCallManager extends ScheduleCallDom {
  final ScheduleCacheService local;
  final NotificationService notifications;

  ScheduleCallManager({
    required this.local,
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
}

final scheduleCallManagerProvider = Provider<ScheduleCallManager>((ref) {
  return ScheduleCallManager(
    local: ref.watch(scheduleCacheServiceProvider),
    notifications: NotificationService(),
  );
});
