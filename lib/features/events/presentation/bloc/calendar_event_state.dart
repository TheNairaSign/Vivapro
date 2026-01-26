import 'package:equatable/equatable.dart';
import 'package:vivapro/features/events/data/calendar_event.dart';

abstract class CalendarEventState extends Equatable {
  const CalendarEventState();

  @override
  List<Object?> get props => [];
}

class CalendarEventInitial extends CalendarEventState {}

class CalendarEventLoading extends CalendarEventState {}

class CalendarEventLoaded extends CalendarEventState {
  final List<CalendarEvent> events;

  const CalendarEventLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class CalendarEventError extends CalendarEventState {
  final String message;

  const CalendarEventError({required this.message});

  @override
  List<Object?> get props => [message];
}
