import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/scheduled_calls_page.dart';
import 'package:vivapro/pages/home/widgets/upcoming_reminder_card.dart';

class UpcomingRemindersSection extends ConsumerWidget {
  const UpcomingRemindersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocBuilder<ScheduleCallBloc, ScheduleCallState>(
      builder: (context, state) {
        if (state is ScheduleCallLoaded) {
          final now = DateTime.now();
          final allSchedules = state.scheduleCalls.map((call) {
            final callDateTime = DateTime(
              call.date.year,
              call.date.month,
              call.date.day,
              call.time.hour,
              call.time.minute,
            );
            return (call: call, dateTime: callDateTime);
          }).toList();

          // Filter for upcoming calls OR missed calls from the last 24 hours
          final displayedCalls = allSchedules.where((item) {
            if (item.dateTime.isAfter(now)) return true;
            // Include missed calls from the last 24 hours
            return item.dateTime.isAfter(now.subtract(const Duration(hours: 24)));
          }).toList();

          if (displayedCalls.isEmpty) {
            return const SizedBox.shrink();
          }

          // Sort by date/time (closest to now first)
          displayedCalls.sort((a, b) => a.dateTime.compareTo(b.dateTime));

          final limitedCalls = displayedCalls.take(3).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Reminders',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScheduledCallsPage()),
                      );
                    },
                    child: Text(
                      'View All',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...limitedCalls.map((item) => Padding(
                padding: const EdgeInsetsGeometry.only(bottom: 10),
                child: UpcomingReminderCard(call: item.call, callDateTime: item.dateTime),
              )),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
