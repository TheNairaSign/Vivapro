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

  void updateCallPriority(CallPriority priority) {
    _callPriority = priority;
    notifyListeners();
  }

  void updateCallFrequency(CallFrequency frequency) {
    _callFrequency = frequency;
    notifyListeners();
  }

  void updateProfilePhoto(String? url) {
    _profilePhotoUrl = url;
    notifyListeners();
  }
}
