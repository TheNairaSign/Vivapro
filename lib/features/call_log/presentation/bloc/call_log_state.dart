import 'package:vivapro/features/call_log/data/call_log_model.dart';
import 'package:vivapro/features/call_log/data/models/insight_model.dart';

abstract class CallLogState {}

class CallLogInitial extends CallLogState {}

class CallLogLoading extends CallLogState {}

class CallLogFailure extends CallLogState {
  final String message;

  CallLogFailure(this.message);
}

class CallLogSuccess extends CallLogState {
  final List<CallLogModel> callLogEntries;
  final List<InsightModel> insights;

  CallLogSuccess({required this.callLogEntries, required this.insights});
}
