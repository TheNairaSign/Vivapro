import 'package:call_log/call_log.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/failure.dart';

class CallLogRepository {
  Future<Either<Failure, Iterable<CallLogEntry>>> getCallLogs() async {
    try {
      final callLogs = await CallLog.query();
      return Right(callLogs);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, int>> deleteCallLog(String id) async {
    try {
      final callLogs = await CallLog.deleteCallLog(id);
      return Right(callLogs);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, int>> deleteAllCallLogs() async {
    try {
      final callLogs = await CallLog.deleteAllCallLogs();
      return Right(callLogs);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

final callLogRepository = Provider<CallLogRepository>(
  (ref) => CallLogRepository(),
);
