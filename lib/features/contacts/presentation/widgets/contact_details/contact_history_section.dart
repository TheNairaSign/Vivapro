import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/core/utils/get_time_ago.dart';

class ContactHistorySection extends StatelessWidget {
  final Contact contact;

  const ContactHistorySection({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<CallLogBloc, CallLogState>(
          builder: (context, state) {
            if (state is CallLogSuccess) {
              // Filter call logs for this contact
              final contactLogs = state.callLogEntries
                  .where((log) {
                    final contactPhones = contact.phones
                        .map((p) => p.number)
                        .toList();
                    return contactPhones.any(
                      (phone) =>
                          log.number?.contains(
                            phone.replaceAll(RegExp(r'[^\d]'), ''),
                          ) ??
                          false,
                    );
                  })
                  .take(2)
                  .toList();

              if (contactLogs.isEmpty) {
                return _buildEmptyHistory(context);
              }

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: contactLogs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final log = entry.value;
                    return Column(
                      children: [
                        _buildHistoryItem(log),
                        if (index < contactLogs.length - 1)
                          Divider(
                            height: 1,
                            indent: 60,
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                          ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
            return _buildEmptyHistory(context);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyHistory(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(Ionicons.call_outline, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No recent calls',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(dynamic log) {
    final isOutgoing = log.callType == CallType.outgoing;
    final isMissed = log.callType == CallType.missed;
    final date = DateTime.fromMillisecondsSinceEpoch(log.timestamp ?? 0);
    final timeAgo = formatTimeAgo(date);
    final duration = log.duration != null ? _formatDuration(log.duration!) : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isMissed
                  ? Colors.red.withValues(alpha: 0.15)
                  : Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isOutgoing ? Ionicons.arrow_up : Ionicons.arrow_down,
              color: isMissed ? Colors.red : Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOutgoing
                      ? 'Outgoing Call'
                      : isMissed
                      ? 'Missed Call'
                      : 'Incoming Call',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '$timeAgo${duration.isNotEmpty ? ' • $duration' : ''}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }
}
