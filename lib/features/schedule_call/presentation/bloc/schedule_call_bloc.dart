import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';

class ScheduleCallBloc extends Bloc<ScheduleCallEvent, ScheduleCallState> {
  final ScheduleCallManager _manager;

  ScheduleCallBloc({required ScheduleCallManager manager}) : _manager = manager, super(ScheduleCallInitial()) {
    on<ScheduleCallFetch>(_onFetch);
    on<ScheduleCallAdd>(_onAdd);
    on<ScheduleCallReschedule>(_onReschedule);
    on<ScheduleCallDelete>(_onDelete);
  }

  Future<void> _onFetch(
    ScheduleCallFetch event,
    Emitter<ScheduleCallState> emit,
  ) async {
    emit(ScheduleCallLoading());
    await emit.forEach<List<ScheduleCall>>(
      _manager.watchScheduledCalls(),
      onData: (scheduleCalls) => ScheduleCallLoaded(scheduleCalls: scheduleCalls),
      onError: (error, stackTrace) => ScheduleCallError(message: error.toString()),
    );
  }

  Future<void> _onAdd(
    ScheduleCallAdd event,
    Emitter<ScheduleCallState> emit,
  ) async {
    final result = await _manager.scheduleCall(event.scheduleCall);
    result.fold(
      (failure) => emit(ScheduleCallError(message: failure.message)),
      (_) {
        // Success: The stream subscription in _onFetch will update the state automatically
      },
    );
  }

  Future<void> _onReschedule(
    ScheduleCallReschedule event,
    Emitter<ScheduleCallState> emit,
  ) async {
    final result = await _manager.rescheduleCall(event.scheduleCall);
    result.fold(
      (failure) => emit(ScheduleCallError(message: failure.message)),
      (_) {
        // Success: The stream subscription in _onFetch will update the state automatically
      },
    );
  }

  Future<void> _onDelete(
    ScheduleCallDelete event,
    Emitter<ScheduleCallState> emit,
  ) async {
    final result = await _manager.deleteSchedule(event.scheduleId);
    result.fold(
      (failure) => emit(ScheduleCallError(message: failure.message)),
      (_) {
        // Success: The stream subscription in _onFetch will update the state automatically
      },
    );
  }
}
