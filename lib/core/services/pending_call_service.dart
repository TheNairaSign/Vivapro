import 'package:shared_preferences/shared_preferences.dart';

class PendingCallService {
  static const _pendingCallContactIdKey = 'pending_call_contact_id';
  static const _pendingCallTimestampKey = 'pending_call_timestamp';
  static const _pendingCallActivityIdKey = 'pending_call_activity_id';

  Future<void> setPendingCall(String contactId, {int? activityId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingCallContactIdKey, contactId);
    await prefs.setInt(_pendingCallTimestampKey, DateTime.now().millisecondsSinceEpoch);
    if (activityId != null) {
      await prefs.setInt(_pendingCallActivityIdKey, activityId);
    }
  }

  Future<Map<String, dynamic>?> getPendingCall() async {
    final prefs = await SharedPreferences.getInstance();
    final contactId = prefs.getString(_pendingCallContactIdKey);
    final timestamp = prefs.getInt(_pendingCallTimestampKey);
    final activityId = prefs.getInt(_pendingCallActivityIdKey);

    if (contactId != null && timestamp != null) {
      return {
        'contactId': contactId, 
        'timestamp': timestamp,
        'activityId': activityId,
      };
    }
    return null;
  }

  Future<void> clearPendingCall() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingCallContactIdKey);
    await prefs.remove(_pendingCallTimestampKey);
    await prefs.remove(_pendingCallActivityIdKey);
  }
}
