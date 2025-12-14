import 'package:vivapro/call_log/data/call_log_model.dart';

abstract class CallLogState {}

class CallLogInitial extends CallLogState {}

class CallLogLoading extends CallLogState {}

class CallLogFailure extends CallLogState {
  final String message;

  CallLogFailure(this.message);
}

class CallLogSuccess extends CallLogState {
  final List<CallLogModel> callLogEntries;

  CallLogSuccess(this.callLogEntries);
}