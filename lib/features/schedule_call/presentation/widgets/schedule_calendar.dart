import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vivapro/features/events/data/calendar_event.dart';

class ScheduleCalendar extends StatelessWidget {
  const ScheduleCalendar({
    super.key, 
    required this.calendarState, 
    required this.onFormatChanged,
    required this.onPageChanged,
  });
  final CalendarState calendarState;
  final void Function(CalendarFormat format) onFormatChanged;
  final void Function(DateTime focusedDay) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return TableCalendar<dynamic>(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: calendarState.focusedDay,
      calendarFormat: calendarState.calendarFormat,
      rowHeight: 52,
      daysOfWeekHeight: 30,
      selectedDayPredicate: (day) => isSameDay(calendarState.selectedDay, day),
      eventLoader: (day) => calendarState.eventsForDay(day),
      onDaySelected: (selectedDay, focusedDay) => calendarState.onDaySelected(selectedDay, focusedDay),
      onFormatChanged: (format) => onFormatChanged(format),
      onPageChanged: (focusedDay) => calendarState.focusedDay = focusedDay,
      calendarStyle: CalendarStyle(
        markerDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        markerSize: 5,
        markersMaxCount: 3,
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: events.take(3).map((event) {
                Color dotColor;
                if (event is CalendarEvent) {
                  dotColor = event.color;
                } else {
                  dotColor = Theme.of(context).colorScheme.primary;
                }
                
                return Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: isSameDay(date, calendarState.selectedDay)
                        ? Colors.white
                        : dotColor,
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class CalendarState {
  DateTime focusedDay;
  DateTime? selectedDay;
  CalendarFormat calendarFormat;
  final List<dynamic> Function(DateTime day) eventsForDay;
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  CalendarState({
    required this.focusedDay,
    this.selectedDay,
    this.calendarFormat = CalendarFormat.month,
    required this.eventsForDay,
    required this.onDaySelected,
  });
}