import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_bloc.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_state.dart';
import 'package:vivapro/features/events/presentation/widgets/event_card.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/scheduled_calls_page.dart';
import 'package:vivapro/features/events/data/calendar_event.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/pages/home/widgets/upcoming_reminder_card.dart';
import 'package:vivapro/widgets/view_all.dart';

class UpcomingRemindersSection extends ConsumerStatefulWidget {
  const UpcomingRemindersSection({super.key});

  @override
  ConsumerState<UpcomingRemindersSection> createState() => _UpcomingRemindersSectionState();
}

class _UpcomingRemindersSectionState extends ConsumerState<UpcomingRemindersSection> {

  @override
  void initState() {
    super.initState();
    context.read<ScheduleCallBloc>().add(ScheduleCallFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCallBloc, ScheduleCallState>(
      builder: (context, scheduleState) {
        return BlocBuilder<CalendarEventBloc, CalendarEventState>(
          builder: (context, eventState) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final tomorrow = today.add(const Duration(days: 1));

            // Extract relevant schedules
            List<({ScheduleCall call, DateTime dateTime})> displayedSchedules = [];
            if (scheduleState is ScheduleCallLoaded) {
              displayedSchedules = scheduleState.scheduleCalls.map((call) {
                final callDateTime = DateTime(
                  call.date.year,
                  call.date.month,
                  call.date.day,
                  call.time.hour,
                  call.time.minute,
                );
                return (call: call, dateTime: callDateTime);
              }).where((item) {
                if (item.dateTime.isAfter(now)) return true;
                // Include missed calls from the last 24 hours
                return item.dateTime.isAfter(now.subtract(const Duration(hours: 24)));
              }).toList();
              
              displayedSchedules.sort((a, b) => a.dateTime.compareTo(b.dateTime));
            }

            // Extract relevant events (Today or Tomorrow)
            List<CalendarEvent> displayedEvents = [];
            if (eventState is CalendarEventLoaded) {
              final allEvents = eventState.events;
              displayedEvents = allEvents.where((event) {
                final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
                return eventDate == today || eventDate == tomorrow;
              }).toList();
              
              displayedEvents.sort((a, b) {
                final dtA = DateTime(a.date.year, a.date.month, a.date.day, a.timeHour, a.timeMinute);
                final dtB = DateTime(b.date.year, b.date.month, b.date.day, b.timeHour, b.timeMinute);
                return dtA.compareTo(dtB);
              });
            }

            if (displayedSchedules.isEmpty && displayedEvents.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Reminders',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (displayedSchedules.isNotEmpty)
                      ViewAll(
                        title: "All Reminders",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ScheduledCallsPage()),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Show most imminent schedule
                if (displayedSchedules.isNotEmpty) ...[
                  ...displayedSchedules.take(1).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: UpcomingReminderCard(call: item.call, callDateTime: item.dateTime),
                  )),
                ],

                // Show most imminent event (today or tomorrow)
                if (displayedEvents.isNotEmpty) ...[
                  ...displayedEvents.take(1).map((event) => EventCard(event: event)),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
