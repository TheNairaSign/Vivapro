import 'package:intl/intl.dart';

String formatTimeAgo(DateTime date) {
  // Simple helper
  final diff = DateTime.now().difference(date);
  if (diff.inDays > 1) return DateFormat('MMM d').format(date);
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inHours > 0) return '${diff.inHours} hours ago';
  if (diff.inMinutes > 0) return '${diff.inMinutes} mins ago';
  return 'Just now';
}
