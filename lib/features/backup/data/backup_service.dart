import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupService {

  Future<void> enableBackup() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('backupEnabled', true);
  }

  Future<void> disableBackup() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('backupEnabled', false);
  }

  Future<bool> isBackupEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('backupEnabled') ?? false;
  }

  Future<void> setLastBackupTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastBackupTime', time.toIso8601String());
  }

  Future<DateTime?> getLastBackupTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString('lastBackupTime');
    return timeStr != null ? DateTime.parse(timeStr) : null;
  }
  
}

final backupServiceProvider = Provider<BackupService>((ref) => BackupService());
