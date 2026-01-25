import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/backup/bloc/backup_bloc.dart';
import 'package:vivapro/features/backup/bloc/backup_event.dart';
import 'package:vivapro/features/backup/bloc/backup_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivapro/components/show_flushbar.dart';
import 'package:vivapro/features/backup/data/backup_service.dart';
import 'package:vivapro/features/profile/logic/profile_controller.dart';

class BackupSettingsSection extends ConsumerStatefulWidget {
  const BackupSettingsSection({super.key});

  @override
  ConsumerState<BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends ConsumerState<BackupSettingsSection> {
  DateTime? _lastBackupTime;

  @override
  void initState() {
    super.initState();
    _loadBackupSettings();
  }

  Future<void> _loadBackupSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        final timeStr = prefs.getString('lastBackupTime');
        _lastBackupTime = timeStr != null ? DateTime.parse(timeStr) : null;
      });
    }
  }

  Future<void> _toggleBackup(bool value) async {
    if (value) {
      await ref.read(profileControllerProvider.notifier).enableBackup();
    } else {
      await ref.read(profileControllerProvider.notifier).disableBackup();
    }
    // No need to manually refresh backupStatusProvider if it was a StateProvider,
    // but since it's a StreamProvider on Prefs, we might need to trigger a refresh
    // or change it to a StateProvider.
    ref.invalidate(backupStatusProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBackupEnabled = ref.watch(backupStatusProvider).value ?? false;

    return BlocListener<BackupBloc, BackupState>(
      listener: (context, state) {
        if (state is BackupSuccess) {
          showFlushbarCustom(context, 'Backup Success', state.message, color: Colors.green);
          _updateLastBackupTime();
        } else if (state is BackupFailure) {
          showFlushbarCustom(context, 'Backup Failed', state.error, color: theme.colorScheme.error);
        } else if (state is RestoreBackupSuccess) {
          showFlushbarCustom(context, 'Restore Success', state.message, color: Colors.blue);
          _updateLastBackupTime();
        } else if (state is RestoreBackupFailure) {
          showFlushbarCustom(context, 'Restore Failed', state.error, color: theme.colorScheme.error);
        }
      },
      child: _buildBody(context, isBackupEnabled),
    );
  }

  Future<void> _updateLastBackupTime() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastBackupTime', now.toIso8601String());
    setState(() {
      _lastBackupTime = now;
    });
  }

  Widget _buildBody(BuildContext context, bool isBackupEnabled) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, "GOOGLE DRIVE BACKUP"),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSwitchTile(
                context,
                icon: EvaIcons.google,
                title: "Enable Drive Backup",
                subtitle: "Mirror your local data to Google Drive App Data",
                value: isBackupEnabled,
                onChanged: _toggleBackup,
              ),
              if (isBackupEnabled) ...[
                const Divider(height: 1),
                _buildActionTile(
                  context,
                  icon: EvaIcons.syncOutline,
                  title: "Backup Now",
                  subtitle: _lastBackupTime != null 
                      ? "Last backup: ${_formatDate(_lastBackupTime!)}"
                      : "No backup performed yet",
                  onTap: (context) {
                    context.read<BackupBloc>().add(InitiateBackupEvent());
                  },
                  isDangerous: false,
                ),
                const Divider(height: 1),
                _buildActionTile(
                  context,
                  icon: EvaIcons.downloadOutline,
                  title: "Restore from Drive",
                  subtitle: "Replace local data with latest cloud backup",
                  onTap: (context) {
                    _showRestoreConfirmDialog(context);
                  },
                  isDangerous: true,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  void _showRestoreConfirmDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Confirm Restore"),
        content: const Text(
          "This will clear all local data and replace it with your cloud backup. This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BackupBloc>().add(RestoreBackupEvent());
            },
            child: Text(
              "Restore",
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      secondary: Icon(
        icon,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: theme.colorScheme.primary,
      inactiveThumbColor: theme.colorScheme.onSurface.withValues(alpha: 0.8),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Function(BuildContext) onTap,
    required bool isDangerous,
  }) {
    final theme = Theme.of(context);
    return BlocBuilder<BackupBloc, BackupState>(
      builder: (context, state) {
        final isLoading = state is BackupLoading || state is RestoreBackupLoading;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          leading: isLoading 
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  icon,
                  color: isDangerous 
                      ? theme.colorScheme.error.withValues(alpha: 0.8)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600, 
              fontSize: 15,
              color: isDangerous ? theme.colorScheme.error : null,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          onTap: isLoading ? null : () => onTap(context),
        );
      },
    );
  }
}
