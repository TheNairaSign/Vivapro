abstract class BackupEvent {}

class InitiateBackupEvent extends BackupEvent {}

class RestoreBackupEvent extends BackupEvent {}

class CancelBackupEvent extends BackupEvent {}