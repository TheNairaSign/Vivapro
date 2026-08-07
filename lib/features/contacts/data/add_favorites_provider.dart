import 'package:flutter/material.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/enums/priority.dart';

class AddFavoritesProvider extends ChangeNotifier {
  CallFrequency _callFrequency = CallFrequency.daily;
  CallFrequency get callFrequency => _callFrequency;

  CallPriority _callPriority = CallPriority.medium;
  CallPriority get callPriority => _callPriority;

  String? _profilePhotoUrl;
  String? get profilePhotoUrl => _profilePhotoUrl;

  /// ISO weekday(s) (1=Mon..7=Sun) selected for weekly/custom checkups.
  List<int> _checkupWeekdays = [];
  List<int> get checkupWeekdays => List.unmodifiable(_checkupWeekdays);

  /// Day(s) of month (1-31) selected for monthly/custom checkups.
  List<int> _checkupMonthDays = [];
  List<int> get checkupMonthDays => List.unmodifiable(_checkupMonthDays);

  void updateCallPriority(CallPriority priority) {
    _callPriority = priority;
    notifyListeners();
  }

  void updateCallFrequency(CallFrequency frequency) {
    _callFrequency = frequency;
    // Seed a sensible default the first time a day-based frequency is picked.
    final today = DateTime.now();
    if (frequency == CallFrequency.weekly && _checkupWeekdays.isEmpty) {
      _checkupWeekdays = [today.weekday];
    } else if (frequency == CallFrequency.monthly && _checkupMonthDays.isEmpty) {
      _checkupMonthDays = [today.day];
    } else if (frequency == CallFrequency.custom &&
        _checkupWeekdays.isEmpty &&
        _checkupMonthDays.isEmpty) {
      _checkupWeekdays = [today.weekday];
    }
    notifyListeners();
  }

  void toggleWeekday(int weekday) {
    final updated = List<int>.from(_checkupWeekdays);
    if (updated.contains(weekday)) {
      updated.remove(weekday);
    } else {
      updated.add(weekday);
    }
    _checkupWeekdays = updated..sort();
    notifyListeners();
  }

  void toggleMonthDay(int day) {
    final updated = List<int>.from(_checkupMonthDays);
    if (updated.contains(day)) {
      updated.remove(day);
    } else {
      updated.add(day);
    }
    _checkupMonthDays = updated..sort();
    notifyListeners();
  }

  void initialize({
    CallFrequency? frequency,
    CallPriority? priority,
    String? photoUrl,
    List<int>? checkupWeekdays,
    List<int>? checkupMonthDays,
    DateTime? createdAt,
  }) {
    _callFrequency = frequency ?? CallFrequency.daily;
    _callPriority = priority ?? CallPriority.medium;
    _profilePhotoUrl = photoUrl;

    // Legacy favorites saved before this feature have no stored days: default
    // from when the contact was originally favorited, not "today", so editing
    // them doesn't silently move their schedule.
    final anchor = createdAt ?? DateTime.now();
    final needsWeekdayDefault =
        _callFrequency == CallFrequency.weekly ||
        (_callFrequency == CallFrequency.custom &&
            (checkupMonthDays == null || checkupMonthDays.isEmpty));
    _checkupWeekdays = checkupWeekdays != null && checkupWeekdays.isNotEmpty
        ? List<int>.from(checkupWeekdays)
        : (needsWeekdayDefault ? [anchor.weekday] : <int>[]);
    _checkupMonthDays = checkupMonthDays != null && checkupMonthDays.isNotEmpty
        ? List<int>.from(checkupMonthDays)
        : (_callFrequency == CallFrequency.monthly ? [anchor.day] : <int>[]);

    notifyListeners();
  }

  void updateProfilePhoto(String? url) {
    _profilePhotoUrl = url;
    notifyListeners();
  }
}
