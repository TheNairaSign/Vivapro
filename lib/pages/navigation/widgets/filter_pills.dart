import 'package:flutter/material.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class FilterPills extends StatelessWidget {
  const FilterPills({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          _buildPill(context, 'All', true),
          const SizedBox(width: 12),
          _buildPill(context, 'Calls', false),
          const SizedBox(width: 12),
          _buildPill(context, 'Reminders', false),
        ],
      ),
    );
  }

  Widget _buildPill(BuildContext context, String label, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerColor = isSelected
        ? Colors.lightBlue
        : GlobalColors.containerColor(context);

    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.grey[300] : Colors.grey[600]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF2D8CFF).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : (isDark
                  ? []
                  : []), // No shadow for unselected in dark mode usually
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
