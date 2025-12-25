import 'package:flutter/material.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/extensions/capitalization.dart';
import 'package:vivapro/core/theme/global_colors.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlue : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: null,
        ),
        child: Text(
          widget.frequency.name.capitalize(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected? Colors.white : Color(0xFF98A2B3),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}