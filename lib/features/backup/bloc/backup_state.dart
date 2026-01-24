import 'package:equatable/equatable.dart';

class BackupState extends Equatable {
  const BackupState();

  @override
  List<Object> get props => [];
}

class BackupInitial extends BackupState {}

class BackupLoading extends BackupState {}

class RestoreBackupLoading extends BackupState {}

class BackupSuccess extends BackupState {
  final String message;

  const BackupSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RestoreBackupSuccess extends BackupState {
  final String message;

  const RestoreBackupSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RestoreBackupFailure extends BackupState {
  final String error;

  const RestoreBackupFailure(this.error);

  @override
  List<Object> get props => [error];
}

class BackupFailure extends BackupState {
  final String error;

  const BackupFailure(this.error);

  @override
  List<Object> get props => [error];
}
