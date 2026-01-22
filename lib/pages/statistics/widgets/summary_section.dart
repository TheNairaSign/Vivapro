import 'package:flutter/material.dart';
import 'package:vivapro/features/call_log/data/call_log_model.dart';
import 'package:vivapro/pages/statistics/widgets/summary_card.dart';
import 'package:vivapro/pages/statistics/widgets/top_caller_info.dart';

// ignore: must_be_immutable
class SummarySection extends StatefulWidget {
  const SummarySection(this.logs, {super.key});
  final List<CallLogModel> logs;

  @override
  State<SummarySection> createState() => _SummarySectionState();
}

class _SummarySectionState extends State<SummarySection> {
  String _selectedFilter = 'Weekly'; 

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _filterLogs(widget.logs);
    final totalCalls = filteredLogs.length;
    final totalDurationSeconds = filteredLogs.fold<int>(
      0,
      (previousValue, element) => previousValue + (element.duration ?? 0),
    );
    final durationFormatted = _formatDuration(totalDurationSeconds);

    return Column(
      children: [
        // Filter Chips
        Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 24),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ['Daily', 'Weekly', 'Monthly'].map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(filter),
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  checkmarkColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[600],
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300]!,
                    ),
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),

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

   List<CallLogModel> _filterLogs(List<CallLogModel> logs) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    return logs.where((log) {
      final logDate = log.date;
      switch (_selectedFilter) {
        case 'Daily':
          return logDate.isAfter(startOfDay);
        case 'Weekly':
          final startOfWeek = now.subtract(const Duration(days: 7));
          return logDate.isAfter(startOfWeek);
        case 'Monthly':
          final startOfMonth = now.subtract(const Duration(days: 30));
          return logDate.isAfter(startOfMonth);
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
    } else {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).floor();
      return '${hours}h ${minutes}m';
    }
  }

    MapEntry<String, int>? _getTopCaller(List<CallLogModel> logs) {
    if (logs.isEmpty) return null;
    final counts = <String, int>{};
    for (var log in logs) {
      final name = (log.name != null && log.name!.isNotEmpty)
          ? log.name!
          : (log.formattedNumber ?? 'Unknown');
      counts[name] = (counts[name] ?? 0) + 1;
    }

    if (counts.isEmpty) return null;

    final sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.first;
  }
}