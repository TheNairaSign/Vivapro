import 'package:flutter/material.dart';
import 'package:vivapro/core/extensions/capitalization.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';

class ManualLogForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ActivityType selectedType;
  final ValueChanged<ActivityType?> onTypeChanged;
  final ValueChanged<String?> onNotesSaved;

  const ManualLogForm({
    super.key,
    required this.formKey,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onNotesSaved,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Log',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1D1E),
          ),
        ),
        const SizedBox(height: 16),
        Form(
          key: formKey,
          child: Column(
            children: [
              DropdownButtonFormField<ActivityType>(
                initialValue: selectedType,
                decoration: InputDecoration(
                  labelText: 'Interaction Type',
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.withValues(alpha: .6), width: .2)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: .5)
                  ),
                  filled: true,
                ),
                items: ActivityType.values.map((type) {
                  IconData icon;
                  switch (type) {
                    case ActivityType.call:
                      icon = Icons.phone;
                      break;
                    case ActivityType.message:
                      icon = Icons.message;
                      break;
                    case ActivityType.meeting:
                      icon = Icons.people;
                      break;
                    case ActivityType.other:
                      icon = Icons.more_horiz;
                      break;
                  }

                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary,),
                        const SizedBox(width: 8),
                        Text(type.name.capitalize(), style: Theme.of(context).textTheme.bodyMedium,),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: onTypeChanged,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Add details about this interaction...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.withValues(alpha: .6), width: .5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: .5,
                    ),
                  ),
                  filled: true
                ),
                maxLines: 3,
                onSaved: onNotesSaved,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
