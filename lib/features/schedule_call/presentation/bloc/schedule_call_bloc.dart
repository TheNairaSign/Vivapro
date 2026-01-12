import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/repositories/schedule_call_repository.dart';

class ScheduleCallBloc extends Bloc<ScheduleCallEvent, ScheduleCallState> {
  final ScheduleCallRepository _repository;

  ScheduleCallBloc({required ScheduleCallRepository repository}) : _repository = repository, super(ScheduleCallInitial()) {
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
      _repository.watchScheduledCalls(),
      onData: (scheduleCalls) => ScheduleCallLoaded(scheduleCalls: scheduleCalls),
      onError: (error, stackTrace) => ScheduleCallError(message: error.toString()),
    );
  }

  Future<void> _onAdd(
    ScheduleCallAdd event,
    Emitter<ScheduleCallState> emit,
  ) async {
    final result = await _repository.scheduleCall(event.scheduleCall);
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
    final result = await _repository.rescheduleCall(event.scheduleCall);
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
    final result = await _repository.deleteSchedule(event.scheduleId);
    result.fold(
      (failure) => emit(ScheduleCallError(message: failure.message)),
      (_) {
        // Success: The stream subscription in _onFetch will update the state automatically
      },
    );
  }
}
