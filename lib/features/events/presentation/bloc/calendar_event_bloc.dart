import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/features/events/dom/calendar_event_manager.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_event.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_state.dart';

class CalendarEventBloc extends Bloc<CalendarEventEvent, CalendarEventState> {
  final CalendarEventManager _manager;

  CalendarEventBloc({required CalendarEventManager manager}) : _manager = manager, super(CalendarEventInitial()) {
    on<CalendarEventFetch>(_onFetch);
    on<CalendarEventAdd>(_onAdd);
    on<CalendarEventDelete>(_onDelete);
  }

  Future<void> _onFetch(
    CalendarEventFetch event,
    Emitter<CalendarEventState> emit,
  ) async {
    emit(CalendarEventLoading());
    await emit.forEach(
      _manager.watchEvents(),
      onData: (events) => CalendarEventLoaded(events: events),
      onError: (error, stackTrace) => CalendarEventError(message: error.toString()),
    );
  }

  Future<void> _onAdd(
    CalendarEventAdd event,
    Emitter<CalendarEventState> emit,
  ) async {
    final result = await _manager.addEvent(event.event);
    result.fold(
      (failure) => emit(CalendarEventError(message: failure.message)),
      (_) async {
        if (event.addToCalendar) {
          await _manager.addToCalendar(event.event);
        }
      },
    );
  }

  Future<void> _onDelete(
    CalendarEventDelete event,
    Emitter<CalendarEventState> emit,
  ) async {
    final result = await _manager.deleteEvent(event.eventId);
    result.fold(
      (failure) => emit(CalendarEventError(message: failure.message)),
      (_) {},
    );
  }
}
