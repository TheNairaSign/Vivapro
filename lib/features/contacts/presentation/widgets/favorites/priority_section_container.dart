import 'package:flutter/material.dart';
import 'package:vivapro/core/enums/priority.dart';
import 'package:vivapro/core/extensions/capitalization.dart';

class PrioritySectionContainer extends StatelessWidget {
  const PrioritySectionContainer({
    super.key,
    required this.priority,
    required this.isSelected,
    required this.onTap,
  });

  final CallPriority priority;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _priorityIcon {
    return switch (priority) {
      CallPriority.high => Icons.star,
      CallPriority.medium => Icons.radio_button_checked,
      CallPriority.low => Icons.arrow_downward,
    };
  }

  Color get _iconColor {
    return switch (priority) {
      CallPriority.high => Colors.green,
      CallPriority.medium => Colors.orange,
      CallPriority.low => Colors.red,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? _iconColor.withValues(alpha: isDark ? 0.12 : 0.08)
              : (isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02)),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected 
                ? _iconColor.withValues(alpha: 0.5) 
                : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05)),
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _priorityIcon,
              color: isSelected ? _iconColor : const Color(0xFF98A2B3),
              size: 26,
            ),
            const SizedBox(height: 10),
            Text(
              priority.name.capitalize(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected 
                    ? (isDark ? Colors.white : Colors.black87) 
                    : const Color(0xFF98A2B3),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
