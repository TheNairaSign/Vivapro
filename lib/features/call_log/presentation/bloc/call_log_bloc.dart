import 'package:bloc/bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/features/call_log/data/call_log_model.dart';
import 'package:vivapro/features/call_log/data/models/insight_model.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/features/call_log/repositories/call_log_repository.dart';
import 'package:vivapro/features/contacts/repositories/contact_repository.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_event.dart';

class CallLogBloc extends Bloc<CallLogEvent, CallLogState> {
  final CallLogRepository _logRepository;
  final ContactRepository _contactRepository;

  CallLogBloc(this._logRepository, this._contactRepository)
    : super(CallLogInitial()) {
    on<GetCallLogs>(_loadCallLog);
  }

  Future<void> _loadCallLog(
    GetCallLogs event,
    Emitter<CallLogState> emit,
  ) async {
    emit(CallLogLoading());
    try {
      final contacts = await _contactRepository.getContacts();
      final callLog = await _logRepository.getCallLogs();

      callLog.fold((failure) => emit(CallLogFailure(failure.message)), (right) {
        final callLogModels = right
            .map((e) => CallLogModel.fromCallLogEntry(e))
            .toList();
        final insights = _generateInsights(callLogModels, contacts);
        emit(CallLogSuccess(callLogEntries: callLogModels, insights: insights));
      });
    } catch (e) {
      emit(CallLogFailure(e.toString()));
    }
  }

  List<InsightModel> _generateInsights(
    List<CallLogModel> logs,
    List<Contact> contacts,
  ) {
    if (logs.isEmpty) {
      return [];
    }

    final Map<String, CallLogModel> latestCalls = {};

    // Find the latest call for each number
    for (var log in logs) {
      final number = log.number;
      if (number != null && number.isNotEmpty) {
        if (!latestCalls.containsKey(number) ||
            (log.timestamp ?? 0) > (latestCalls[number]?.timestamp ?? 0)) {
          latestCalls[number] = log;
        }
      }
    }

    final List<InsightModel> insights = [];
    final now = DateTime.now();
    const insightThreshold = Duration(days: 7);

    latestCalls.forEach((number, log) {
      final lastCallDate = log.date;
      final difference = now.difference(lastCallDate);

      if (difference > insightThreshold) {
        // Find the contact name
        String contactName = number;
        String contactId = '';
        try {
          final contact = contacts.firstWhere(
            (c) => c.phones.any(
              (p) =>
                  p.number.replaceAll(RegExp(r'[^0-9]'), '') ==
                  number.replaceAll(RegExp(r'[^0-9]'), ''),
            ),
          );
          contactName = contact.displayName;
          contactId = contact.id;
        } catch (_) {
          // Contact not found, but we can still create an insight for the number
        }

        insights.add(
          InsightModel(
            contactName: contactName,
            contactId: contactId,
            phoneNumber: number,
            daysSinceLastCall: difference.inDays,
            type: InsightType.noContact,
          ),
        );
      }
    });

    // Sort insights by the most days since last call
    insights.sort((a, b) => b.daysSinceLastCall.compareTo(a.daysSinceLastCall));

    return insights;
  }
}
