import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/components/show_flushbar.dart';
import 'package:vivapro/core/services/navigator_service.dart';
import 'package:vivapro/core/services/pending_call_service.dart';
import 'package:vivapro/features/backup/bloc/backup_bloc.dart';
import 'package:vivapro/features/backup/bloc/backup_event.dart';
import 'package:vivapro/pages/navigation/widgets/manual_log_bottom_sheet.dart';

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
    } else if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
  }

  void _handleAppResumed() async {
    final pendingCallService = PendingCallService();
    final pendingCall = await pendingCallService.getPendingCall();

    if (pendingCall != null) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(pendingCall['timestamp']);
      final now = DateTime.now();
      final difference = now.difference(timestamp);

      // Only show banner if the call was initiated in the last 5 minutes
      if (difference.inMinutes < 5) {
        await pendingCallService.clearPendingCall();
        final contact = await FlutterContacts.getContact(pendingCall['contactId']);

        if (contact != null && navigatorKey.currentContext!.mounted) {
          final navigatorState = navigatorKey.currentState;
          if (navigatorState == null) return;
          final navContext = navigatorState.context;

          showFlushbarCustom(
            navContext,
            'Log Call?',
            'Log your recent call with ${contact.displayName}?',
            duration: const Duration(seconds: 10),
            mainButton: Row(
              children: [
                TextButton(
                  onPressed: () {
                    navigatorState.pop();
                    showModalBottomSheet(
                      context: navContext,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ManualLogBottomSheet(contact: contact),
                    );
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () => navigatorState.pop(),
                  child: const Text('No'),
                ),
              ],
            ),
          );
        }
      } else {
        // Clear the pending call if it's too old
        await pendingCallService.clearPendingCall();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
