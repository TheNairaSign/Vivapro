import 'package:flutter/material.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';

class FilterPills extends StatelessWidget {
  final ActivityType? selectedFilter;
  final ValueChanged<ActivityType?> onFilterChanged;

  const FilterPills({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<ActivityType?> filterOptions = [null, ...ActivityType.values];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filterOptions.map((filterType) {
          String label;
          if (filterType == null) {
            label = 'All';
          } else {
            label = filterType.toString().split('.').last;
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(label),
              selected: selectedFilter == filterType,
              onSelected: (selected) {
                if (selected) {
                  onFilterChanged(filterType);
                }
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: isDark ? const Color(0xFF2C2C3E) : const Color(0xFFF2F4F7),
              labelStyle: TextStyle(
                color: selectedFilter == filterType
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
