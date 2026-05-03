import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:vivapro/core/enums/priority.dart';

class PriorityInfoContainer extends StatelessWidget {
  final CallPriority selectedPriority;

  const PriorityInfoContainer({
    super.key,
    required this.selectedPriority,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final priorityData = _getPriorityData(selectedPriority);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: priorityData.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    priorityData.icon,
                    size: 16,
                    color: priorityData.color,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${priorityData.label} Role',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1D2939),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey(selectedPriority),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      priorityData.impact,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1.6,
                            color: isDark ? Colors.white70 : const Color(0xFF475467),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFEAECF0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            EvaIcons.flashOutline,
                            size: 12,
                            color: priorityData.color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Affects: ${priorityData.affects}',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: isDark ? Colors.white60 : const Color(0xFF667085),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _PriorityDisplayData _getPriorityData(CallPriority priority) {
    switch (priority) {
      case CallPriority.high:
        return const _PriorityDisplayData(
          label: 'High Priority',
          impact: 'This contact is part of your inner circle. They will stay pinned at the top of your favorites and receive the most consistent engagement prompts.',
          affects: 'Ranking & Persistence',
          color: Colors.green,
          icon: EvaIcons.star,
        );
      case CallPriority.medium:
        return const _PriorityDisplayData(
          label: 'Medium Priority',
          impact: 'Standard connection. These contacts receive balanced visibility with regular reminders to keep the relationship steady and healthy.',
          affects: 'Standard Ranking',
          color: Colors.orange,
          icon: EvaIcons.radio,
        );
      case CallPriority.low:
        return const _PriorityDisplayData(
          label: 'Low Priority',
          impact: 'For casual or distant connections. Keeps them in your circle with minimal disruption and lower visibility in your primary dashboard.',
          affects: 'Minimal Prompts',
          color: Colors.red,
          icon: EvaIcons.arrowDown,
        );
    }
  }
}

class _PriorityDisplayData {
  final String label;
  final String impact;
  final String affects;
  final Color color;
  final IconData icon;

  const _PriorityDisplayData({
    required this.label,
    required this.impact,
    required this.affects,
    required this.color,
    required this.icon,
  });
}
