import 'package:call_log/call_log.dart';

class CallLogModel {
  final String? formattedNumber;
  final String? cachedMatchedNumber;
  final String? number;
  final String? name;
  final CallType? callType;
  final int? timestamp;
  final int? duration;
  final String? phoneAccountId;
  final String? simDisplayName;
  final DateTime date;

  CallLogModel({
    this.formattedNumber,
    this.simDisplayName,
    required this.cachedMatchedNumber,
    required this.number,
    required this.name,
    required this.callType,
    required this.timestamp,
    required this.duration,
    required this.phoneAccountId,
    required this.date,
  });

  factory CallLogModel.fromCallLogEntry(CallLogEntry entry) {
    return CallLogModel(
      formattedNumber: entry.formattedNumber,
      cachedMatchedNumber: entry.cachedMatchedNumber,
      number: entry.number,
      name: entry.name,
      callType: entry.callType,
      timestamp: entry.timestamp,
      duration: entry.duration,
      phoneAccountId: entry.phoneAccountId,
      simDisplayName: entry.simDisplayName,
      date: DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0),
    );
  }
}
