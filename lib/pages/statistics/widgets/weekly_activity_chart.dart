import 'package:flutter/material.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';

class WeeklyActivityChart extends StatelessWidget {
  final List<ActivityLog> logs;

  const WeeklyActivityChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    // Process logs to get counts per day for the last 7 days
    final now = DateTime.now();
    final weekDays = List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return day;
    });

    final counts = weekDays.map((day) {
      return logs.where((log) {
        final logDate = log.timestamp;
        return logDate.year == day.year &&
            logDate.month == day.month &&
            logDate.day == day.day &&
            log.type == ActivityType.call; // Only count calls
      }).length;
    }).toList();

    final maxCount = counts.isEmpty ? 1 : counts.reduce((a, b) => a > b ? a : b);
    final displayMax = maxCount == 0 ? 1 : maxCount;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
            BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calls',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${counts.fold(0, (a, b) => a + b)} this week',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final count = counts[index];
              final heightFactor = count / displayMax;
              // Format day name (e.g., 'Mon')
              final dayName = _getDayName(weekDays[index].weekday);

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: heightFactor),
                    duration: Duration(milliseconds: 500 + (index * 100)),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Container(
                        width: 12,
                        height: 100 * value + 10, // Minimum height of 10
                        decoration: BoxDecoration(
                          color: index == 6 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withAlpha(76),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
