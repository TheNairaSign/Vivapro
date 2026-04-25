import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/core/app_constants.dart';

class FilterPills extends StatelessWidget {
  final ActivityType? selectedFilter;
  final ValueChanged<ActivityType?> onFilterChanged;

  const FilterPills({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  IconData _getIcon(ActivityType? type) {
    switch (type) {
      case ActivityType.call:
        return EvaIcons.phoneOutline;
      case ActivityType.message:
        return EvaIcons.messageSquareOutline;
      case ActivityType.meeting:
        return EvaIcons.peopleOutline;
      case ActivityType.other:
        return EvaIcons.moreHorizontalOutline;
      case null:
        return EvaIcons.gridOutline;
    }
  }

  String _getLabel(ActivityType? type) {
    if (type == null) return 'All';
    final name = type.name;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<ActivityType?> filterOptions = [null, ...ActivityType.values];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppConstants.padding.left),
        itemCount: filterOptions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filterType = filterOptions[index];
          final isSelected = selectedFilter == filterType;
          final colorScheme = Theme.of(context).colorScheme;

          return GestureDetector(
            onTap: () => onFilterChanged(filterType),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIcon(filterType),
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.grey[400] : Colors.grey[700]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getLabel(filterType),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.grey[300] : Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
