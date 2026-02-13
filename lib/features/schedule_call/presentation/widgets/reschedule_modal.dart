import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_avatar.dart';

class RescheduleModal extends ConsumerWidget {
  final ScheduleCall scheduleCall;
  const RescheduleModal({super.key, required this.scheduleCall});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    FavoriteAvatar(contact: scheduleCall.contact, radius: 30),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reschedule with ${scheduleCall.contact.displayName}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Snooze reminder for...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildGridItem(
                        context,
                        icon: Icons.timer_outlined,
                        title: 'Later',
                        subtitle: '30 minutes',
                        onTap: () => _handleReschedule(context, ref, const Duration(minutes: 30)),
                      ),
                      _buildGridItem(
                        context,
                        icon: Icons.hourglass_empty,
                        title: 'In an hour',
                        subtitle: 'Focus time',
                        onTap: () => _handleReschedule(context, ref, const Duration(hours: 1)),
                      ),
                      _buildGridItem(
                        context,
                        icon: Icons.wb_sunny_outlined,
                        title: 'Tomorrow',
                        subtitle: '9:00 AM',
                        onTap: () => _handleReschedule(context, ref, null, isTomorrow: true),
                      ),
                      _buildGridItem(
                        context,
                        icon: Icons.calendar_today_outlined,
                        title: 'Custom...',
                        subtitle: 'Pick date & time',
                        onTap: () => _handleCustomReschedule(context, ref),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Mark as done = Delete schedule
                    ref.read(scheduleCallManagerProvider).deleteSchedule(scheduleCall.id);
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Mark as Done',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red[600], fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleReschedule(BuildContext context, WidgetRef ref, Duration? offset, {bool isTomorrow = false}) async {
    final now = DateTime.now();
    DateTime newDate;

    if (isTomorrow) {
      newDate = DateTime(now.year, now.month, now.day + 1, 9, 0);
    } else {
      newDate = now.add(offset!);
    }

    final updatedCall = scheduleCall.copyWith(
      date: DateTime(newDate.year, newDate.month, newDate.day),
      time: TimeOfDay(hour: newDate.hour, minute: newDate.minute),
    );

    await ref.read(scheduleCallManagerProvider).rescheduleCall(updatedCall);
    if (context.mounted) Navigator.of(context).pop(true);
  }

  Future<void> _handleCustomReschedule(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null && context.mounted) {
        final updatedCall = scheduleCall.copyWith(
          date: date,
          time: time,
        );
        await ref.read(scheduleCallManagerProvider).rescheduleCall(updatedCall);
        if (context.mounted) Navigator.of(context).pop(true);
      }
    }
  }

  Widget _buildGridItem(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
