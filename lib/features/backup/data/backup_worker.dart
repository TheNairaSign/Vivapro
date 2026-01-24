import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/core/services/google_drive_service.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';

import 'dart:developer' as developer;

class BackupWorker {
  final GoogleDriveBackupService _googleDriveService;

  BackupWorker(this._googleDriveService);

  Future<Either<Failure, String>> backupAll() async {
    try {
      await _googleDriveService.backup();
      developer.log('Backup successful');
      return right('Backup successful');
    } catch (e) {
      developer.log('Backup failed: $e');
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, String>> restoreAll() async {
    try {
      await _googleDriveService.restore();
      return right('Restore successful');
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

final backupWorkerProvider = Provider<BackupWorker>((ref) {
  final isar = ref.watch(isarProvider);
  return BackupWorker(GoogleDriveBackupService(isar));
});