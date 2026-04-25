import 'package:flutter/material.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';

class ActivityChart extends StatefulWidget {
  final List<ActivityLog> logs;
  final String period;

  const ActivityChart({super.key, required this.logs, this.period = 'Weekly'});

  @override
  State<ActivityChart> createState() => _ActivityChartState();
}

class _ActivityChartState extends State<ActivityChart> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = false;

  late List<DateTime> _timePoints;
  late List<int> _counts;

  @override
  void initState() {
    super.initState();
    _computeData();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        _updateArrows();
      }
    });
  }

  @override
  void didUpdateWidget(ActivityChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.logs != widget.logs || oldWidget.period != widget.period) {
      _computeData();
    }
  }

  void _computeData() {
    final now = DateTime.now();
    final isMonthly = widget.period == 'Monthly';

    if (isMonthly) {
      _timePoints = List.generate(12, (i) {
        return DateTime(now.year, now.month - (11 - i), 1);
      });
    } else {
      _timePoints = List.generate(7, (i) {
        return now.subtract(Duration(days: 6 - i));
      });
    }

    // Single-pass grouping — O(n + m) instead of O(n × m)
    final countMap = <String, int>{};
    for (final log in widget.logs) {
      if (log.type != ActivityType.call) continue;
      final key = isMonthly
          ? '${log.timestamp.year}-${log.timestamp.month}'
          : '${log.timestamp.year}-${log.timestamp.month}-${log.timestamp.day}';
      countMap[key] = (countMap[key] ?? 0) + 1;
    }

    _counts = _timePoints.map((point) {
      final key = isMonthly
          ? '${point.year}-${point.month}'
          : '${point.year}-${point.month}-${point.day}';
      return countMap[key] ?? 0;
    }).toList();
  }

  void _updateArrows() {
    if (!_scrollController.hasClients) return;
    final isMonthly = widget.period == 'Monthly';
    setState(() {
      _showLeftArrow = isMonthly && _scrollController.offset > 10;
      _showRightArrow = isMonthly &&
          _scrollController.offset <
              _scrollController.position.maxScrollExtent - 10;
    });
  }

  void _scrollListener() {
    if (widget.period != 'Monthly') return;
    _updateArrows();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scroll(bool left) {
    final offset = left
        ? (_scrollController.offset - 150)
            .clamp(0.0, _scrollController.position.maxScrollExtent)
        : (_scrollController.offset + 150)
            .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMonthly = widget.period == 'Monthly';

    final displayMax =
        _counts.isEmpty || _counts.every((c) => c == 0)
            ? 1
            : _counts.reduce((a, b) => a > b ? a : b);

    final totalLabel = isMonthly
        ? '+${_counts.last} this month'
        : widget.period == 'Daily'
            ? '+${_counts.last} today'
            : '+${_counts.fold(0, (a, b) => a + b)} this week';

    final isLight = Theme.of(context).brightness == Brightness.light;
    final shadowColor = isLight ? Colors.black : Colors.transparent;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withAlpha(12),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      totalLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (isMonthly) ...[
                    const SizedBox(width: 6),
                    _ScrollArrow(
                      left: true,
                      enabled: _showLeftArrow,
                      onTap: () => _scroll(true),
                    ),
                    const SizedBox(width: 2),
                    _ScrollArrow(
                      left: false,
                      enabled: _showRightArrow,
                      onTap: () => _scroll(false),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const Spacer(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOutQuart,
            switchOutCurve: Curves.easeInQuart,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.02, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: () {
              // Group Daily and Weekly for animation purposes
              final animationKey = isMonthly ? 'Monthly' : 'DailyWeekly';

              Widget chartContent = Row(
                key: ValueKey('${animationKey}_row'),
                mainAxisAlignment: isMonthly
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(_timePoints.length, (index) {
                  final count = _counts[index];
                  final heightFactor = displayMax == 0 ? 0.0 : count / displayMax;
                  final label = isMonthly
                      ? _getMonthName(_timePoints[index].month)
                      : _getDayName(_timePoints[index].weekday);
                  final isLast = index == _timePoints.length - 1;

                  return Container(
                    margin: isMonthly
                        ? const EdgeInsets.symmetric(horizontal: 10)
                        : EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: heightFactor),
                          duration: Duration(milliseconds: 500 + (index * 100)),
                          curve: Curves.easeOutBack,
                          builder: (context, value, _) {
                            return Container(
                              width: 12,
                              height: 70 * value + 10,
                              decoration: BoxDecoration(
                                color: isLast
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withAlpha(76),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  );
                }),
              );

              if (isMonthly) {
                chartContent = SingleChildScrollView(
                  key: const ValueKey('Monthly_scroll'),
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: chartContent,
                );
              }

              return chartContent;
            }(),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekday >= 1 && weekday <= 7 ? days[weekday - 1] : '';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return month >= 1 && month <= 12 ? months[month - 1] : '';
  }
}

class _ScrollArrow extends StatelessWidget {
  final bool left;
  final bool enabled;
  final VoidCallback onTap;

  const _ScrollArrow({
    required this.left,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.25,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            left ? Icons.chevron_left : Icons.chevron_right,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}