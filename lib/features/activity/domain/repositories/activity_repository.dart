import 'package:dartz/dartz.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';

abstract class ActivityRepository {
  Future<Either<Failure, List<ActivityLog>>> getActivities();
  Future<Either<Failure, int>> logActivity(ActivityLog activity);
  Future<Either<Failure, void>> deleteActivity(int id);
  Stream<List<ActivityLog>> watchActivities();
}
