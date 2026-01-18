import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_call_page.dart';
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
        _showNoScheduleDialog(selectedDay);
      }
    }
  }

  void _showNoScheduleDialog(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("No Scheduled Call"),
        content: Text("Would you like to schedule a call for ${date.day}/${date.month}/${date.year}?"),
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
                      scheduleCall: ScheduleCall(
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

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: TableCalendar<ScheduleCall>(
                      firstDay: DateTime.now().subtract(const Duration(days: 365)),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      rowHeight: 52,
                      daysOfWeekHeight: 30,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      eventLoader: (day) => _getEventsForDay(day, allCalls),
                      onDaySelected: (selectedDay, focusedDay) => _onDaySelected(selectedDay, focusedDay, allCalls),
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarStyle: CalendarStyle(
                        markerDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        markerSize: 5,
                        markersMaxCount: 1,
                        markerMargin: const EdgeInsets.only(top: 6),
                        todayDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
                        ),
                        todayTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        selectedDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        outsideDaysVisible: false,
                        defaultTextStyle: const TextStyle(fontWeight: FontWeight.w500),
                        weekendTextStyle: TextStyle(
                          color: Colors.red.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                        weekendStyle: TextStyle(
                          color: Colors.red[200],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              letterSpacing: -0.5,
                            ),
                        headerPadding: const EdgeInsets.symmetric(vertical: 16),
                        leftChevronIcon: Icon(EvaIcons.chevronLeft, color: Theme.of(context).colorScheme.primary),
                        rightChevronIcon: Icon(EvaIcons.chevronRight, color: Theme.of(context).colorScheme.primary),
                        leftChevronMargin: const EdgeInsets.only(left: 12),
                        rightChevronMargin: const EdgeInsets.only(right: 12),
                      ),
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          if (events.isEmpty) return null;
                          return Positioned(
                            bottom: 8,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isSameDay(date, _selectedDay)
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Row(
                      children: [
                        Text(
                          "Planned for ${_selectedDay?.day}",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 40,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Icon(EvaIcons.calendarOutline, size: 56, color: Colors.grey[300]),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "Rest Day",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "No calls scheduled for this day",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 24),
                              OutlinedButton.icon(
                                onPressed: () => _selectedDay != null ? _showNoScheduleDialog(_selectedDay!) : null,
                                icon: const Icon(EvaIcons.plus, size: 18),
                                label: const Text("Plan a Call"),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  side: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          key: ValueKey('events_${_selectedDay?.millisecondsSinceEpoch}'),
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
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
          );
        },
      ),
    );
  }
}
