import 'package:shared_preferences/shared_preferences.dart';

class PendingCallService {
  static const _pendingCallContactIdKey = 'pending_call_contact_id';
  static const _pendingCallTimestampKey = 'pending_call_timestamp';

  Future<void> setPendingCall(String contactId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingCallContactIdKey, contactId);
    await prefs.setInt(_pendingCallTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<Map<String, dynamic>?> getPendingCall() async {
    final prefs = await SharedPreferences.getInstance();
    final contactId = prefs.getString(_pendingCallContactIdKey);
    final timestamp = prefs.getInt(_pendingCallTimestampKey);

    if (contactId != null && timestamp != null) {
      return {'contactId': contactId, 'timestamp': timestamp};
    }
    return null;
  }

  Future<void> clearPendingCall() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingCallContactIdKey);
    await prefs.remove(_pendingCallTimestampKey);
  }
}
