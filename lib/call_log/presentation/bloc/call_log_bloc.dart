import 'package:bloc/bloc.dart';
import 'package:vivapro/call_log/data/call_log_model.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_event.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/call_log/repositories/call_log_repository.dart';

class CallLogBloc extends Bloc<CallLogEvent, CallLogState>{
  final CallLogRepository _logRepository;
  CallLogBloc (this._logRepository) : super(CallLogInitial()) {
    on<GetCallLogs>(_loadCallLog);
  }

  Future<void> _loadCallLog(GetCallLogs event, Emitter<CallLogState> emit) async {
    emit(CallLogLoading());
    try {
      final callLog = await _logRepository.getCallLogs();
      callLog.fold(
        (failure) => emit(CallLogFailure(failure.message)), 
        (right) => emit(CallLogSuccess(right.map((e) => CallLogModel.fromCallLogEntry(e)).toList()))
      );
    } catch (e) {
      emit(CallLogFailure(e.toString()));
    }
  }
}