import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/features/backup/bloc/backup_bloc.dart';
import 'package:vivapro/features/backup/bloc/backup_event.dart';

class LifecycleManager extends StatefulWidget {
  final Widget child;
  const LifecycleManager({super.key, required this.child});

  @override
  State<LifecycleManager> createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      context.read<BackupBloc>().add(InitiateBackupEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
