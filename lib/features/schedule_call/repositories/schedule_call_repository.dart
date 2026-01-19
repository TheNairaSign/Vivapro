import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/core/services/notification_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';

class ScheduleCallRepository {
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

  Stream<List<ScheduleCall>> watchScheduledCalls() {
    final ref = _userSchedulesRef;
    if (ref == null) return Stream.value([]);

    return ref.orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ScheduleCall.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  final _notificationService = NotificationService();

  Future<Either<Failure, Unit>> scheduleCall(ScheduleCall scheduleCall) async {
    try {
      final ref = _userSchedulesRef;
      if (ref == null) return left(Failure('User not authenticated'));

      final docRef = await ref.add(scheduleCall.toJson());
      final callWithId = scheduleCall.copyWith(id: docRef.id);
      await _notificationService.scheduleCallNotification(callWithId);
      
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Reschedule a call (Update)
  Future<Either<Failure, Unit>> rescheduleCall(ScheduleCall scheduleCall) async {
    try {
      final ref = _userSchedulesRef;
      if (ref == null) return left(Failure('User not authenticated'));
      if (scheduleCall.id.isEmpty) return left(Failure('Invalid schedule ID'));

      await ref.doc(scheduleCall.id).update(scheduleCall.toJson());
      await _notificationService.scheduleCallNotification(scheduleCall);

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> deleteSchedule(String scheduleId) async {
    try {
      final ref = _userSchedulesRef;
      if (ref == null) return left(Failure('User not authenticated'));

      await ref.doc(scheduleId).delete();
      await _notificationService.cancelNotification(scheduleId.hashCode);

      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

   Future<bool> setReminder(ContactInsight insight) async {
      final now = DateTime.now();
      final tomorrow = DateTime(
        now.year,
        now.month,
        now.day + 1,
        10,
        0,
      );

      return setContactReminder(
        insight.contact, 
        tomorrow,
        note: 'Follow up from insight: ${insight.message}',
      );
    }

    Future<bool> setContactReminder(
      FavoriteContact contact, 
      DateTime scheduledDateTime, 
      {String? note}
    ) async {
      final call = ScheduleCall(
        contact: contact.contactDetails,
        date: scheduledDateTime,
        time: TimeOfDay(hour: scheduledDateTime.hour, minute: scheduledDateTime.minute),
        note: note ?? 'Reminder for ${contact.contactDetails.displayName}',
      );

      final result = await scheduleCall(call);

      return result.fold(
        (failure) => false,
        (r) => true,
      );
    }
}

final scheduleCallRepositoryProvider = Provider<ScheduleCallRepository>((ref) {
  return ScheduleCallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref
  );
});