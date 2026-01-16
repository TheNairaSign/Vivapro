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
      CallPriority.medium => Colors.yellow,
      CallPriority.low => Colors.red,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? _iconColor.withValues(alpha: 0.1)
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: _iconColor, width: 1.5) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? _iconColor.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _priorityIcon,
                color: isSelected ? _iconColor : const Color(0xFF98A2B3),
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              priority.name.capitalize(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
