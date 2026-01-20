import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_dom.dart';

class ScheduleCacheService extends ScheduleCallDom {
  final Isar isar;

  ScheduleCacheService(this.isar);

  Future<Either<Failure, List<ScheduleCall>>> getAllScheduledCalls() async {
    try {
      final calls = await isar.scheduleCalls.where().findAll();
      return right(calls);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> scheduleCall(ScheduleCall schedule) async {
    try {
      await isar.writeTxn(() async {
      await isar.scheduleCalls.put(schedule);
    });
    } catch (e) {
      return left(Failure(e.toString()));
    }
    return right('');
  }

  Future<Either<Failure, Unit>> cacheSchedules(List<ScheduleCall> schedules) async {
    try {
      await isar.writeTxn(() => isar.scheduleCalls.putAll(schedules));
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> replaceCache(List<ScheduleCall> schedules) async {
    try {
      await isar.writeTxn(() async {
        await isar.scheduleCalls.clear();
        await isar.scheduleCalls.putAll(schedules);
      });
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<ScheduleCall>> watchScheduledCalls() {
    return isar.scheduleCalls.where().watch(fireImmediately: true);
  }

  @override
  Future<Either<Failure, Unit>> deleteSchedule(String id) async {
    try {
      await isar.writeTxn(() async {
        await isar.scheduleCalls.where().idEqualTo(id).deleteAll();
      });
    } catch (e) {
      return left(Failure(e.toString()));
    }
    return right(unit);
  }

  Future<void> clearCache() async {
    await isar.writeTxn(() async {
      await isar.scheduleCalls.clear();
    });
  }

  @override
  Future<Either<Failure, Unit>> rescheduleCall(ScheduleCall scheduleCall) async {
    try {
      await isar.writeTxn(() async {
        await isar.scheduleCalls.put(scheduleCall);
      });
    } catch (e) {
      return left(Failure(e.toString()));
    }
    return right(unit);
  }

  Future<List<ScheduleCall>> getSchedulesForDay(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    return await isar.scheduleCalls
        .filter()
        .dateBetween(startOfDay, endOfDay)
        .findAll();
  }

}

final scheduleCacheServiceProvider = Provider<ScheduleCacheService>((ref) {
  final isar = ref.watch(isarProvider);
  return ScheduleCacheService(isar);
});
