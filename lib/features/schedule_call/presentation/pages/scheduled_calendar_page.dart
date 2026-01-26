import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vivapro/core/utils/format_date.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_call_page.dart';
import 'package:vivapro/features/schedule_call/presentation/widgets/no_events_card.dart';
import 'package:vivapro/features/schedule_call/presentation/widgets/schedule_calendar.dart';
import 'package:vivapro/pages/contact_picker_page.dart';
import 'package:vivapro/pages/home/widgets/upcoming_reminder_card.dart';
import 'package:vivapro/widgets/custom_back_button.dart';

class ScheduledCalendarPage extends StatefulWidget {
  const ScheduledCalendarPage({super.key});

  @override
  State<ScheduledCalendarPage> createState() => _ScheduledCalendarPageState();
}

class _ScheduledCalendarPageState extends State<ScheduledCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    context.read<ScheduleCallBloc>().add(ScheduleCallFetch());
  }

  void onFormatChanged (CalendarFormat format) {
    if (_calendarFormat != format) {
      setState(() {
        _calendarFormat = format;
      });
    }
  }

  void onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  List<ScheduleCall> _getEventsForDay(DateTime day, List<ScheduleCall> allCalls) {
    return allCalls.where((call) => isSameDay(call.date, day)).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay, List<ScheduleCall> allCalls) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      final events = _getEventsForDay(selectedDay, allCalls);
      if (events.isEmpty) {
        _showNoScheduleDialog(selectedDay, isFromCalendar: true);
      }
    }
  }

  String title(DateTime date, {required bool isFromCalendar}) {
    return isFromCalendar ? "No Scheduled Call for ${DateFunctions.formatDay(date, DateTime.now())}" : "Scheduled Call for ${DateFunctions.formatDay(date, DateTime.now())}?";
  }

  String content(DateTime date, {required bool isFromCalendar}) {
    return isFromCalendar 
    ? "Would you like to schedule a call for ${DateFunctions.formatDay(date, DateTime.now())}?" 
    : "No calls scheduled for this day";
  }

  void _showNoScheduleDialog(DateTime date, {required bool isFromCalendar}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title(date, isFromCalendar: isFromCalendar), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        content: Text(content(date, isFromCalendar: isFromCalendar), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final contact = await Navigator.of(context).push<Contact?>(
                MaterialPageRoute(builder: (ctx) => const ContactPickerPage()),
              );
              if (contact != null && context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ScheduleCallPage(
                      contact: contact,
                      scheduleCall: ScheduleCall.create(
                        id: '',
                        contact: contact,
                        date: date,
                        time: TimeOfDay.now(),
                        note: '',
                      ),
                    ),
                  ),
                );
              }
            },
            child: const Text("Schedule"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Call Calendar",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: const CustomBackButton(),
      ),
      body: BlocBuilder<ScheduleCallBloc, ScheduleCallState>(
        builder: (context, state) {
          List<ScheduleCall> allCalls = [];
          if (state is ScheduleCallLoaded) {
            allCalls = state.scheduleCalls;
          }

          final selectedEvents = _selectedDay != null ? _getEventsForDay(_selectedDay!, allCalls) : [];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ScheduleCalendar(
                      calendarState: CalendarState(
                        focusedDay: _focusedDay,
                        selectedDay: _selectedDay,
                        calendarFormat: _calendarFormat,
                        eventsForDay: (day) => _getEventsForDay(day, allCalls),
                        onDaySelected: (selectedDay, focusedDay) => _onDaySelected(selectedDay, focusedDay, allCalls),
                      ),
                      onFormatChanged: onFormatChanged,
                      onPageChanged: onPageChanged,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Planned for ${_selectedDay?.day}",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.05),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: selectedEvents.isEmpty
                        ? Center(
                            key: const ValueKey('no_events'),
                            child: NoEventsCard(
                              onPressed: () {
                              _selectedDay != null ? _showNoScheduleDialog(_selectedDay!, isFromCalendar: false) : null;
                            }),
                          )
                          : ListView.separated(
                              key: ValueKey('events_${_selectedDay?.millisecondsSinceEpoch}'),
                              itemCount: selectedEvents.length,
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final call = selectedEvents[index];
                                return UpcomingReminderCard(call: call, callDateTime: call.date);
                              },
                            ),
                        ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
