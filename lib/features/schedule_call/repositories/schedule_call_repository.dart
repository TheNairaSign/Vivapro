import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_dom.dart';

class ScheduleCallRepository extends ScheduleCallDom {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Ref ref;

  ScheduleCallRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required this.ref,
  })  : _firestore = firestore,
        _auth = auth;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _userSchedulesRef {
    final uid = _userId;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('schedule_calls');
  }

  @override
  Stream<List<ScheduleCall>> watchScheduledCalls() {
    final ref = _userSchedulesRef;
    if (ref == null) return Stream.value([]);

    return ref.orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ScheduleCall.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  @override
  Future<Either<Failure, String>> scheduleCall(ScheduleCall scheduleCall) async {
    try {
      final ref = _userSchedulesRef;
      if (ref == null) return left(Failure('User not authenticated'));

      final docRef = await ref.add(scheduleCall.toJson());
      
      return right(docRef.id);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Reschedule a call (Update)
  @override
  Future<Either<Failure, Unit>> rescheduleCall(ScheduleCall scheduleCall) async {
    try {
      final ref = _userSchedulesRef;
      if (ref == null) return left(Failure('User not authenticated'));
      if (scheduleCall.id.isEmpty) return left(Failure('Invalid schedule ID'));

      await ref.doc(scheduleCall.id).update(scheduleCall.toJson());

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSchedule(String scheduleId) async {
    try {
      final ref = _userSchedulesRef;
      if (ref == null) return left(Failure('User not authenticated'));

      await ref.doc(scheduleId).delete();

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, List<ScheduleCall>>> restoreAllScheduledCalls() async {
    try {
      final ref = _userSchedulesRef;
      if (ref == null) return left(Failure('User not authenticated'));

      final snapshot = await ref.get();
      final calls = snapshot.docs.map((doc) {
        return ScheduleCall.fromMap(doc.id, doc.data());
      }).toList();

      return right(calls);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

}

final scheduleCallRepositoryProvider = Provider<ScheduleCallRepository>((ref) {
  return ScheduleCallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref
  );
});