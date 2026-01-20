import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/backup/bloc/backup_bloc.dart';
import 'package:vivapro/features/backup/bloc/backup_event.dart';
import 'package:vivapro/features/backup/bloc/backup_state.dart';
import 'package:vivapro/features/backup/data/backup_service.dart';
import 'package:vivapro/components/show_flushbar.dart';

class BackupSettingsSection extends ConsumerStatefulWidget {
  const BackupSettingsSection({super.key});

  @override
  ConsumerState<BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends ConsumerState<BackupSettingsSection> {
  bool _isBackupEnabled = false;
  DateTime? _lastBackupTime;

  @override
  void initState() {
    super.initState();
    _loadBackupSettings();
  }

  Future<void> _loadBackupSettings() async {
    final service = ref.read(backupServiceProvider);
    final enabled = await service.isBackupEnabled();
    final lastTime = await service.getLastBackupTime();
    if (mounted) {
      setState(() {
        _isBackupEnabled = enabled;
        _lastBackupTime = lastTime;
      });
    }
  }

  Future<void> _toggleBackup(bool value) async {
    final service = ref.read(backupServiceProvider);
    if (value) {
      await service.enableBackup();
    } else {
      await service.disableBackup();
    }
    setState(() {
      _isBackupEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<BackupBloc, BackupState>(
      listener: (context, state) {
        if (state is BackupSuccess) {
          showFlushbar(context, 'Backup Success', state.message, color: Colors.green);
          _updateLastBackupTime();
        } else if (state is BackupFailure) {
          showFlushbar(context, 'Backup Failed', state.error, color: theme.colorScheme.error);
        } else if (state is RestoreBackupSuccess) {
          showFlushbar(context, 'Restore Success', state.message, color: Colors.blue);
        } else if (state is RestoreBackupFailure) {
          showFlushbar(context, 'Restore Failed', state.error, color: theme.colorScheme.error);
        }
      },
      child: _buildBody(context),
    );
  }

  Future<void> _updateLastBackupTime() async {
    final now = DateTime.now();
    await ref.read(backupServiceProvider).setLastBackupTime(now);
    setState(() {
      _lastBackupTime = now;
    });
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, "CLOUD BACKUP"),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSwitchTile(
                context,
                icon: EvaIcons.cloudUploadOutline,
                title: "Enable Cloud Backup",
                subtitle: "Mirror your local data to secure cloud storage",
                value: _isBackupEnabled,
                onChanged: _toggleBackup,
              ),
              if (_isBackupEnabled) ...[
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
                  title: "Restore from Cloud",
                  subtitle: "Download your mirrored data to this device",
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
