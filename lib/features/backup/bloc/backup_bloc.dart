import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/features/backup/bloc/backup_event.dart';
import 'package:vivapro/features/backup/bloc/backup_state.dart';
import 'package:vivapro/features/backup/data/backup_worker.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final BackupWorker backupWorker;
  BackupBloc({required this.backupWorker}) : super(BackupInitial()) {
    on<InitiateBackupEvent>(onBackupEvent);
    on<RestoreBackupEvent>(onRestoreEvent);
  }

  Future<void> onBackupEvent(BackupEvent event, Emitter<BackupState> emit) async {
    emit(BackupLoading());
    try {
      final result = await backupWorker.backupAll();
      result.fold((l) => emit(BackupFailure(l.message)), (r) => emit(BackupSuccess(r)));
    } catch (e) {
      emit(BackupFailure(e.toString()));
    }
  }

  Future<void> onRestoreEvent(RestoreBackupEvent event, Emitter<BackupState> emit) async {
    emit(RestoreBackupLoading());
    try {
      final result = await backupWorker.restoreAll();
      result.fold((l) => emit(RestoreBackupFailure(l.message)), (r) => emit(RestoreBackupSuccess(r)));
    } catch (e) {
      emit(RestoreBackupFailure(e.toString()));
    }
  }

/*
  Future<void> onEnableBackupEvent(EnableBackupEvent event, Emitter<BackupState> emit) async {
    emit(BackupLoading());
    try {
      await backupWorker.enableBackup();
      emit(BackupSuccess('Backup enabled'));
    } catch (e) {
      emit(BackupFailure(e.toString()));
    }
  }

  Future<void> onDisableBackupEvent(DisableBackupEvent event, Emitter<BackupState> emit) async {
    emit(BackupLoading());
    try {
      await backupWorker.disableBackup();
      emit(BackupSuccess('Backup disabled'));
    } catch (e) {
      emit(BackupFailure(e.toString()));
    }
  }
  */

}