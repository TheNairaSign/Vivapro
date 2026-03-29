import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_avatar.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';
import 'package:vivapro/features/schedule_call/presentation/widgets/reschedule_modal.dart';

class CallReminderScreen extends ConsumerWidget {
  final ScheduleCall schedule;

  const CallReminderScreen({super.key, required this.schedule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final contact = schedule.contact;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Blur/Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.3),
                    Colors.black,
                  ],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.black.withValues(alpha: 0.5)),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Column(
              children: [
                const Spacer(),
                
                // Reminder Label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.alarm, color: theme.colorScheme.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'SCHEDULED REMINDER',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Avatar
                FavoriteAvatar(contact: contact, radius: 80),
                
                const SizedBox(height: 24),
                
                // Name
                Text(
                  contact.displayName ?? 'John Doe',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                if (schedule.note.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    schedule.note,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                const Spacer(flex: 2),

                // Call Button
                _ActionButton(
                  onTap: () async {
                    final phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : null;
                    if (phoneNumber != null && contact.id != null) {
                      final interactionTracker = ref.read(interactionTrackerProvider);
                      await interactionTracker.recordInteraction(contact.id!);
                      
                      // Delete the schedule after calling
                      await ref.read(scheduleCallManagerProvider).deleteSchedule(schedule.id);
                      
                      final uri = Uri(scheme: 'tel', path: phoneNumber);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                      
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  icon: Icons.phone_rounded,
                  label: 'Call Now',
                  color: Colors.greenAccent[700]!,
                  textColor: Colors.white,
                ),

                const SizedBox(height: 20),

                // Reschedule & Dismiss
                Row(
                  children: [
                    Expanded(
                      child: _SecondaryButton(
                        onTap: () async {
                          final result = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => RescheduleModal(scheduleCall: schedule),
                          );
                          if (result == true && context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        icon: Icons.event_repeat_rounded,
                        label: 'Reschedule',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SecondaryButton(
                        onTap: () async {
                          // Just delete the schedule (mark as handled/dismissed)
                          await ref.read(scheduleCallManagerProvider).deleteSchedule(schedule.id);
                          if (context.mounted) Navigator.pop(context);
                        },
                        icon: Icons.close_rounded,
                        label: 'Dismiss',
                        isDestructive: true,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;

  const _ActionButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final bool isDestructive;

  const _SecondaryButton({
    required this.onTap,
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDestructive 
                ? Colors.redAccent.withValues(alpha: 0.3) 
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon, 
              color: isDestructive ? Colors.redAccent : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isDestructive ? Colors.redAccent : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
