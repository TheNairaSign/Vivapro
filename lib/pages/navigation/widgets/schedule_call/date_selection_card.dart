import 'package:flutter/material.dart';

class DateSelectionCard extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelectionCard({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Choose Date",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(primary: Theme.of(context).colorScheme.primary),
              dividerColor: Colors.transparent,
            ),
            child: SizedBox(
              height: 320,
              width: double.infinity,
              child: Builder(
                builder: (BuildContext context) {
                  final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                  final DateTime effectiveInitialDate = selectedDate.isBefore(today) ? today : selectedDate;

                  return CalendarDatePicker(
                    initialDate: effectiveInitialDate,
                    firstDate: today,
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    onDateChanged: onDateSelected,
                  );
                },
              ),
            ),
          ),
          // const SizedBox(height: 10),
        ],
      ),
    );
  }
}