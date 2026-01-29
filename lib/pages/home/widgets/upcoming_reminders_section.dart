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
import 'package:vivapro/pages/home/widgets/upcoming_reminder_card.dart';

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

          final limitedCalls = displayedCalls.take(1).toList(); 

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

              BlocBuilder<CalendarEventBloc, CalendarEventState>(
                builder: (context, eventState) {
                  if (eventState is CalendarEventLoaded) {
                    final now = DateTime.now();
                    final allEvents = eventState.events.map((event) {
                      final eventDateTime = DateTime(
                        event.date.year,
                        event.date.month,
                        event.date.day,
                        event.time.hour,
                        event.time.minute,
                      );
                      return (event: event, dateTime: eventDateTime);
                    }).toList();

                    // // Filter for upcoming events OR missed events from the last 24 hours
                    // final displayedEvents = allEvents.where((item) {
                    //   if (item.dateTime.isAfter(now)) return true;
                    //   // Include missed events from the last 24 hours
                    //   return item.dateTime.isAfter(now.subtract(const Duration(hours: 24)));
                    // }).toList();

                    // if (displayedEvents.isEmpty) {
                    //   return const SizedBox.shrink();
                    // }

                    // // Sort by date/time (closest to now first)
                    allEvents.sort((a, b) => a.dateTime.compareTo(b.dateTime));

                    final limitedEvents = allEvents.take(1).toList();

                    return EventCard(event: limitedEvents.first.event);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
