import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/contacts/presentation/providers/favorite_filter_provider.dart';

class FilterChips extends ConsumerWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(favoriteFilterProvider);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ['All', 'Daily', 'Weekly', 'Monthly', 'Custom'].map((e) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              label: Text(e),
              selected: e == selectedFilter,
              onSelected: (selected) {
                if (selected) {
                  ref.read(favoriteFilterProvider.notifier).setFilter(e);
                }
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              showCheckmark: false,
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: e == selectedFilter 
                    ? Colors.white 
                    : Colors.grey[600],
                fontWeight: e == selectedFilter ? FontWeight.w900 : FontWeight.w500,
              ),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ).toList(),
      ),
    );
  }
}
