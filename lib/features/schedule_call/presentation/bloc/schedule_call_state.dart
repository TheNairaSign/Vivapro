import 'package:flutter/material.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';

@immutable
abstract class ScheduleCallState {}

class ScheduleCallInitial extends ScheduleCallState {}

class ScheduleCallLoading extends ScheduleCallState {}

class ScheduleCallLoaded extends ScheduleCallState {
  final List<ScheduleCall> scheduleCalls;

  ScheduleCallLoaded({required this.scheduleCalls});
}

class ScheduleCallError extends ScheduleCallState {
  final String message;

  ScheduleCallError({required this.message});
}

