import 'package:equatable/equatable.dart';
import 'package:vivapro/features/events/data/calendar_event.dart';

abstract class CalendarEventEvent extends Equatable {
  const CalendarEventEvent();

  @override
  List<Object?> get props => [];
}

class CalendarEventFetch extends CalendarEventEvent {}

class CalendarEventAdd extends CalendarEventEvent {
  final CalendarEvent event;
  final bool addToCalendar;
  const CalendarEventAdd(this.event, {this.addToCalendar = false});

  @override
  List<Object?> get props => [event, addToCalendar];
}

class CalendarEventDelete extends CalendarEventEvent {
  final String eventId;
  const CalendarEventDelete(this.eventId);

  @override
  List<Object?> get props => [eventId];
}
