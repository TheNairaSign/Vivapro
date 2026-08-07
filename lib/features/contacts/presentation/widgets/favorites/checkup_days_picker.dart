import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/features/contacts/data/add_favorites_provider.dart';

const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

/// Lets the user pick which weekday(s) and/or day(s) of month a favorite
/// should be checked up on. Shown conditionally by [FrequencyContainer]
/// based on the currently selected [CallFrequency].
class CheckupDaysPicker extends StatelessWidget {
  const CheckupDaysPicker({super.key, required this.frequency});

  final CallFrequency frequency;

  @override
  Widget build(BuildContext context) {
    final showWeekdays = frequency == CallFrequency.weekly || frequency == CallFrequency.custom;
    final showMonthDays = frequency == CallFrequency.monthly || frequency == CallFrequency.custom;

    if (!showWeekdays && !showMonthDays) {
      return const SizedBox.shrink();
    }

    final favoritesProvider = context.watch<AddFavoritesProvider>();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showWeekdays) ...[
            Text(
              frequency == CallFrequency.custom ? 'Days of Week' : 'Checkup Day(s)',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(7, (index) {
                final weekday = index + 1; // ISO: 1=Mon..7=Sun
                return _DayChip(
                  label: _weekdayLabels[index],
                  isSelected: favoritesProvider.checkupWeekdays.contains(weekday),
                  onTap: () => favoritesProvider.toggleWeekday(weekday),
                );
              }),
            ),
          ],
          if (showWeekdays && showMonthDays) const SizedBox(height: 20),
          if (showMonthDays) ...[
            Text(
              frequency == CallFrequency.custom ? 'Dates of Month' : 'Checkup Date(s)',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(31, (index) {
                final day = index + 1;
                return _DayChip(
                  label: '$day',
                  isSelected: favoritesProvider.checkupMonthDays.contains(day),
                  onTap: () => favoritesProvider.toggleMonthDay(day),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 40),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
