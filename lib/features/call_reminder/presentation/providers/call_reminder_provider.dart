import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';

class CallReminderState {
  final ScheduleCall? activeCall;
  final DateTime? shownAt;

  CallReminderState({this.activeCall, this.shownAt});

  CallReminderState copyWith({ScheduleCall? activeCall, DateTime? shownAt, bool clearCall = false}) {
    return CallReminderState(
      activeCall: clearCall ? null : (activeCall ?? this.activeCall),
      shownAt: clearCall ? null : (shownAt ?? this.shownAt),
    );
  }
}

class CallReminderNotifier extends StateNotifier<CallReminderState> {
  CallReminderNotifier() : super(CallReminderState());

  Timer? _dismissTimer;

  void show(ScheduleCall call) {
    _dismissTimer?.cancel();
    state = state.copyWith(activeCall: call, shownAt: DateTime.now());
    
    // Auto-dismiss after 5 minutes
    _dismissTimer = Timer(const Duration(minutes: 2), () {
      debugPrint("Dismissing Reminder");
      dismiss();
    });
  }

  void dismiss() {
    _dismissTimer?.cancel();
    state = state.copyWith(clearCall: true);
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }
}

final callReminderBannerProvider = StateNotifierProvider<CallReminderNotifier, CallReminderState>((ref) {
  return CallReminderNotifier();
});
