import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';
import 'package:vivapro/features/contacts/dom/favorite_manager.dart';

class BackupWorker {
  final ScheduleCallManager scheduleManager;
  final FavoriteManager favoriteManager;

  BackupWorker({
    required this.scheduleManager,
    required this.favoriteManager,
  });

  Future<Either<Failure, String>> backupAll() async {
    // 1. Backup Favorites
    final favoriteResult = await favoriteManager.syncAllToCloud();
    if (favoriteResult.isLeft()) {
      return favoriteResult.fold((l) => left(l), (r) => right(''));
    }

    // 2. Backup Scheduled Calls
    final scheduleResult = await scheduleManager.syncAllToCloud();
    return scheduleResult.fold(
      (l) => left(l),
      (r) => right('Backup successful'),
    );
  }

  Future<Either<Failure, String>> restoreAll() async {
    // 1. Restore Favorites
    final favoriteResult = await favoriteManager.restoreFromCloud();
    if (favoriteResult.isLeft()) {
      return favoriteResult.fold((l) => left(l), (r) => right(''));
    }

    // 2. Restore Scheduled Calls
    final scheduleResult = await scheduleManager.restoreFromCloud();
    return scheduleResult.fold(
      (l) => left(l),
      (r) => right('Restore successful'),
    );
  }
}

final backupWorkerProvider = Provider<BackupWorker>((ref) {
  return BackupWorker(
    scheduleManager: ref.watch(scheduleCallManagerProvider),
    favoriteManager: ref.watch(favoriteManagerProvider),
  );
});