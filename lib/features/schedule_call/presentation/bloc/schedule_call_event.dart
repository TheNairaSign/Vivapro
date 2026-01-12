import 'package:flutter/material.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';

@immutable
abstract class ScheduleCallEvent {}

class ScheduleCallFetch extends ScheduleCallEvent {}

class ScheduleCallAdd extends ScheduleCallEvent {
  final ScheduleCall scheduleCall;

  ScheduleCallAdd({required this.scheduleCall});
}

class ScheduleCallReschedule extends ScheduleCallEvent {
  final ScheduleCall scheduleCall;

  ScheduleCallReschedule({required this.scheduleCall});
}

class ScheduleCallDelete extends ScheduleCallEvent {
  final String scheduleId;

  ScheduleCallDelete({required this.scheduleId});
}
