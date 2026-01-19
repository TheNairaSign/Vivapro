import 'package:dartz/dartz.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';

abstract class ScheduleCallDom {
  Stream<List<ScheduleCall>> watchScheduledCalls();
  Future<Either<Failure, Unit>> scheduleCall(ScheduleCall scheduleCall);
  Future<Either<Failure, Unit>> rescheduleCall(ScheduleCall scheduleCall);
  Future<Either<Failure, Unit>> deleteSchedule(String id);
}
