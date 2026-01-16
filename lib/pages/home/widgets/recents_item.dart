import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:vivapro/features/call_log/data/call_log_model.dart';
import 'package:vivapro/core/utils/get_call_icon_data.dart';
import 'package:vivapro/core/utils/get_time_ago.dart';

class RecentsItem extends StatelessWidget {
  const RecentsItem({super.key, required this.log});
  final CallLogModel log;

  @override
  Widget build(BuildContext context) {
    final name = (log.name != null && log.name!.isNotEmpty)
        ? log.name!
        : (log.formattedNumber ?? 'Unknown');
    final date = DateTime.fromMillisecondsSinceEpoch(log.timestamp ?? 0);
    final timeAgo = formatTimeAgo(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: log.callType == CallType.missed
                  ? Colors.redAccent.withValues(alpha: .25)
                  : Colors.greenAccent.withValues(alpha: .25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getCallIconData(log.callType),
              color: log.callType == CallType.missed
                  ? Colors.redAccent
                  : Colors.greenAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$timeAgo • 12m 30s', // Duration is mocked for now
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
          if (log.callType == CallType.missed)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D8CFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'Callback',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
