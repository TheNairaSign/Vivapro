import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ['All', 'Daily', 'Weekly', 'Custom']
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(e),
                  selected: e == 'All',
                  onSelected: (_) {},
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
