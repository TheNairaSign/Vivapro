import 'package:flutter/material.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/extensions/capitalization.dart';

class FrequencySelectionChip extends StatefulWidget {
  const FrequencySelectionChip({
    super.key,
    required this.frequency,
    required this.onTap,
    required this.isSelected,
  });
  final CallFrequency frequency;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  State<FrequencySelectionChip> createState() => _FrequencySelectionChipState();
}

class _FrequencySelectionChipState extends State<FrequencySelectionChip> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withBlue(255),
                  ],
                )
              : null,
          color: isSelected
              ? null
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          widget.frequency.name.capitalize(),
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF98A2B3),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
