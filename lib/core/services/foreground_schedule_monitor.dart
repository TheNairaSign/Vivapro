import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/call_reminder/presentation/providers/call_reminder_provider.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';

class ForegroundScheduleMonitor with WidgetsBindingObserver {
  final Ref ref;
  final Set<String> _notifiedIds = {};
  StreamSubscription? _subscription;
  Timer? _periodicTimer;

  ForegroundScheduleMonitor(this.ref);

  List<ScheduleCall> _currentCalls = [];
  final Map<String, Timer> _scheduledTimers = {};

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('App resumed → immediate check');
      _checkSchedules(_currentCalls);
      // Optionally re-schedule timers if needed
      _scheduleTimersForCalls(_currentCalls);
    }
  }

  void start() {
    debugPrint('🚀 ForegroundScheduleMonitor: Starting...');
    WidgetsBinding.instance.addObserver(this);
    
    try {
      final manager = ref.read(scheduleCallManagerProvider);
      debugPrint('✅ ScheduleCallManager obtained');
      
      _subscription = manager.watchScheduledCalls().listen(
        (calls) {
          debugPrint('📡 Received ${calls.length} calls from stream');
          _currentCalls = calls;
          _scheduleTimersForCalls(calls);
          _checkSchedules(calls); // Check immediately
        },
        onError: (error) {
          debugPrint('❌ Error in watchScheduledCalls stream: $error');
        },
        onDone: () {
          debugPrint('⚠️ watchScheduledCalls stream closed');
        },
      );
      debugPrint('✅ Stream subscription created');

      // Check every 1 second as a fallback for faster response (in case timers miss)
      _periodicTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        debugPrint('⏰ Periodic check triggered (${_currentCalls.length} calls cached)');
        if (_currentCalls.isNotEmpty) {
          _checkSchedules(_currentCalls);
        }
      });
      debugPrint('✅ Periodic timer created (5 second interval)');
      
      debugPrint('✅ ForegroundScheduleMonitor started successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error starting ForegroundScheduleMonitor: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  void _scheduleTimersForCalls(List<ScheduleCall> calls) {
    final now = DateTime.now();

    // Cancel existing timers
    for (final timer in _scheduledTimers.values) {
      timer.cancel();
    }
    _scheduledTimers.clear();

    // Schedule precise timers for ALL future calls (no 24-hour limit)
    for (final call in calls) {
      final scheduledDateTime = DateTime(
        call.date.year,
        call.date.month,
        call.date.day,
        call.timeHour,
        call.timeMinute,
      );

      final difference = scheduledDateTime.difference(now);

      // Only schedule timers for future calls
      if (difference.isNegative || difference < const Duration(seconds: 1)) {
        continue;
      }

      debugPrint('⏱️ Scheduling timer for ${call.contact.displayName} in ${difference.inSeconds}s');

      _scheduledTimers[call.id] = Timer(difference, () {
        debugPrint('⏰ Timer fired for ${call.contact.displayName}');
        if (!_notifiedIds.contains(call.id)) {
          _showReminder(call);
          _notifiedIds.add(call.id);
        }
      });
    }
  }

  void _checkSchedules(List<ScheduleCall> calls) {
    final now = DateTime.now();
    debugPrint('=== ForegroundScheduleMonitor: Checking ${calls.length} scheduled calls at ${now.toString()} ===');
    
    for (final call in calls) {
      final scheduledDateTime = DateTime(
        call.date.year,
        call.date.month,
        call.date.day,
        call.timeHour,
        call.timeMinute,
      );

      debugPrint('Call ID: ${call.id}');
      debugPrint('  Contact: ${call.contact.displayName}');
      debugPrint('  Scheduled: $scheduledDateTime');
      debugPrint('  Current: $now');
      debugPrint('  Difference: ${scheduledDateTime.difference(now).inMinutes} minutes');
      debugPrint('  Already notified: ${_notifiedIds.contains(call.id)}');

      // Condition to trigger:
      // 1. Time has reached (scheduledDateTime <= now)
      // 2. Not too old (within last 5 minutes) to avoid spamming old reminders on app start
      // 3. Haven't notified in this session
      final isTimeReached = scheduledDateTime.isBefore(now.add(const Duration(milliseconds: 100))); // Increased precision
      final isNotTooOld = scheduledDateTime.isAfter(now.subtract(const Duration(minutes: 5)));
      final notYetNotified = !_notifiedIds.contains(call.id);

      debugPrint('  Time reached: $isTimeReached');
      debugPrint('  Not too old: $isNotTooOld');
      debugPrint('  Not yet notified: $notYetNotified');

      if (isTimeReached && isNotTooOld && notYetNotified) {
        debugPrint('✅ TRIGGERING in-app reminder for call: ${call.id}');
        _showReminder(call);
        _notifiedIds.add(call.id);
      } else {
        debugPrint('❌ NOT triggering reminder');
      }
      
      // If a call is in the future, ensure it's removed from notifiedIds (e.g. if it was rescheduled)
      if (scheduledDateTime.isAfter(now)) {
        if (_notifiedIds.contains(call.id)) {
          debugPrint('Removing ${call.id} from notified set (rescheduled to future)');
          _notifiedIds.remove(call.id);
        }
      }
    }
    
    if (calls.isEmpty) {
      debugPrint('No scheduled calls found in database');
    }
  }

  void _showReminder(ScheduleCall call) {
    // Instead of showing a full screen, we now show a banner via the provider
    // The HomePage will listen to this provider and display the banner
    Future.microtask(() {
      ref.read(callReminderBannerProvider.notifier).show(call);
    });
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
    debugPrint('ForegroundScheduleMonitor stopped');
    _subscription?.cancel();
    _periodicTimer?.cancel();
    for (var t in _scheduledTimers.values) {
      t.cancel();
    }
    _scheduledTimers.clear();
    _notifiedIds.clear();
  }
}

final foregroundScheduleMonitorProvider = Provider<ForegroundScheduleMonitor>((ref) {
  return ForegroundScheduleMonitor(ref);
});
