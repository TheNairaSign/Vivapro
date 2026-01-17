import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ['All', 'Daily', 'Weekly', 'Monthly', 'Custom']
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilterChip(
                  label: Text(e),
                  selected: e == 'All',
                  onSelected: (_) {},
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  checkmarkColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: e == 'All' 
                        ? Theme.of(context).colorScheme.primary 
                        : Colors.grey[600],
                    fontWeight: e == 'All' ? FontWeight.w900 : FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: e == 'All' 
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                          : Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
