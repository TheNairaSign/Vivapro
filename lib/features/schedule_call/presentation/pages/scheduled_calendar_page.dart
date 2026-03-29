import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vivapro/core/utils/format_date.dart';
import 'package:vivapro/features/events/data/calendar_event.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_bloc.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_event.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_state.dart';
import 'package:vivapro/features/events/presentation/pages/add_event_page.dart';
import 'package:vivapro/features/events/presentation/widgets/event_card.dart';
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
    context.read<CalendarEventBloc>().add(CalendarEventFetch());
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

  List<dynamic> _getEventsForDay(DateTime day, List<ScheduleCall> allCalls, List<CalendarEvent> allEvents) {
    final calls = allCalls.where((call) => isSameDay(call.date, day)).toList();
    final events = allEvents.where((event) => isSameDay(event.date, day)).toList();
    return [...calls, ...events];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay, List<ScheduleCall> allCalls, List<CalendarEvent> allEvents) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final events = _getEventsForDay(selectedDay, allCalls, allEvents);
    if (events.isEmpty) {
      _showAddOptionDialog(selectedDay);
    }
  }

  void _showAddOptionDialog(DateTime date) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Add to Calendar",
              style: Theme.of(sheetContext).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Choose what you want to schedule for ${DateFunctions.formatDay(date, DateTime.now())}",
              textAlign: TextAlign.center,
              style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _OptionCard(
                    icon: EvaIcons.phoneOutline,
                    label: "Schedule Call",
                    color: Theme.of(sheetContext).colorScheme.primary,
                    onTap: () async {
                      Navigator.pop(sheetContext);
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
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _OptionCard(
                    icon: EvaIcons.calendarOutline,
                    label: "Add Event",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => AddEventPage(initialDate: date),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calendar",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: const CustomBackButton(),
      ),
      body: BlocBuilder<ScheduleCallBloc, ScheduleCallState>(
        builder: (context, callState) {
          return BlocBuilder<CalendarEventBloc, CalendarEventState>(
            builder: (context, eventState) {
              List<ScheduleCall> allCalls = [];
              if (callState is ScheduleCallLoaded) {
                allCalls = callState.scheduleCalls;
              }

              List<CalendarEvent> allEvents = [];
              if (eventState is CalendarEventLoaded) {
                allEvents = eventState.events;
              }

              final selectedEvents = _selectedDay != null 
                  ? _getEventsForDay(_selectedDay!, allCalls, allEvents) 
                  : [];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          eventsForDay: (day) => _getEventsForDay(day, allCalls, allEvents),
                          onDaySelected: (selectedDay, focusedDay) => _onDaySelected(selectedDay, focusedDay, allCalls, allEvents),
                        ),
                        onFormatChanged: onFormatChanged,
                        onPageChanged: onPageChanged,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Planned for ${DateFunctions.formatDay(_selectedDay ?? DateTime.now(), DateTime.now())}",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showAddOptionDialog(_selectedDay ?? DateTime.now()),
                          icon: Icon(EvaIcons.plus, color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
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
                                    _selectedDay != null ? _showAddOptionDialog(_selectedDay!) : null;
                                  },
                                ),
                              )
                            : ListView.separated(
                                key: ValueKey('events_${_selectedDay?.millisecondsSinceEpoch}'),
                                itemCount: selectedEvents.length,
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder: (context, index) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final item = selectedEvents[index];
                                  if (item is ScheduleCall) {
                                    return UpcomingReminderCard(call: item, callDateTime: item.date);
                                  } else {
                                    return EventCard(event: item as CalendarEvent);
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

