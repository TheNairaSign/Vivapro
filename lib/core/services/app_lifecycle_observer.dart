import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/features/backup/bloc/backup_bloc.dart';
import 'package:vivapro/features/backup/bloc/backup_event.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final BuildContext context;

  AppLifecycleObserver(this.context);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Trigger backup when app goes to background
      context.read<BackupBloc>().add(InitiateBackupEvent());
    }
  }
}
