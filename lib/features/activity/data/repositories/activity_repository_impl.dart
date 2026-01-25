import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/activity/domain/repositories/activity_repository.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final Isar _isar;

  ActivityRepositoryImpl(this._isar);

  @override
  Future<Either<Failure, List<ActivityLog>>> getActivities() async {
    try {
      final activities = await _isar.activityLogs.where().sortByTimestampDesc().findAll();
      return Right(activities);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> logActivity(ActivityLog activity) async {
    try {
      final id = await _isar.writeTxn(() async {
        return await _isar.activityLogs.put(activity);
      });
      return Right(id);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteActivity(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.activityLogs.delete(id);
      });
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<ActivityLog>> watchActivities() {
    return _isar.activityLogs.where().sortByTimestampDesc().watch(fireImmediately: true);
  }
}

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return ActivityRepositoryImpl(isar);
});
