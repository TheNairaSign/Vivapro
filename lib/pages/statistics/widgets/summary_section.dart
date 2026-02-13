import 'package:flutter/material.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/pages/statistics/widgets/summary_card.dart';
import 'package:vivapro/pages/statistics/widgets/top_caller_info.dart';

// ignore: must_be_immutable
class SummarySection extends StatefulWidget {
  const SummarySection(this.logs, {super.key, this.initialFilter = 'Weekly'});
  final List<ActivityLog> logs;
  final String initialFilter;

  @override
  State<SummarySection> createState() => _SummarySectionState();
}

class _SummarySectionState extends State<SummarySection> {
  late String _selectedFilter; 

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }
  @override
  void didUpdateWidget(SummarySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFilter != widget.initialFilter) {
      _selectedFilter = widget.initialFilter;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _filterLogs(widget.logs);
    final totalCalls = filteredLogs.length;
    final totalDurationSeconds = filteredLogs.fold<int>(
      0,
      (previousValue, element) => previousValue + (element.durationSeconds ?? 0),
    );
    final durationFormatted = _formatDuration(totalDurationSeconds);

    return Column(
      children: [
        const SizedBox(height: 0),

        // Summary Cards
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Total Calls',
                value: totalCalls.toString(),
                icon: Icons.phone_in_talk,
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'Duration',
                value: durationFormatted,
                icon: Icons.timer,
                color: Colors.teal,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        TopCallerInfo(
          title: 'Most Active ($_selectedFilter)',
          caller: _getTopCaller(filteredLogs),
          isOverall: false,
        ),

        const SizedBox(height: 16),
        TopCallerInfo(
          title: 'Top Connected',
          caller: _getTopCaller(widget.logs),
          isOverall: true,
        ),
      ],
    );
  }

  List<ActivityLog> _filterLogs(List<ActivityLog> logs) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    return logs.where((log) {
      final logDate = log.timestamp;
      bool isCall = log.type == ActivityType.call;
      switch (_selectedFilter) {
        case 'Daily':
          return isCall && logDate.isAfter(startOfDay);
        case 'Weekly':
          final startOfWeek = now.subtract(const Duration(days: 7));
          return isCall && logDate.isAfter(startOfWeek);
        case 'Monthly':
          final startOfMonth = now.subtract(const Duration(days: 30));
          return isCall && logDate.isAfter(startOfMonth);
        default:
          return false;
      }
    }).toList();
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    } else if (seconds < 3600) {
      final minutes = (seconds / 60).floor();
      return '${minutes}m';
    }
    else {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).floor();
      return '${hours}h ${minutes}m';
    }
  }

  MapEntry<String, int>? _getTopCaller(List<ActivityLog> logs) {
    if (logs.isEmpty) return null;
    final counts = <String, int>{};
    for (var log in logs) {
      if (log.type == ActivityType.call) { // Only count calls for top caller
        final name = log.favoriteContact?.contactDetails.displayName ?? log.contactName;
        counts[name] = (counts[name] ?? 0) + 1;
      }
    }

    if (counts.isEmpty) return null;

    final sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.first;
  }
}