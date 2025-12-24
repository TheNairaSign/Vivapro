import 'package:flutter/material.dart';
import 'package:vivapro/contacts/presentation/widgets/favorites/frequency_selection_chip.dart';
import 'package:vivapro/contacts/presentation/widgets/favorites/priority_section_container.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/enums/priority.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class FrequencyContainer extends StatefulWidget {
  const FrequencyContainer({super.key});

  @override
  State<FrequencyContainer> createState() => _FrequencyContainerState();
}

class _FrequencyContainerState extends State<FrequencyContainer> {
  CallFrequency _selectedFrequency = CallFrequency.daily;
  CallPriority _selectedPriority = CallPriority.high;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GlobalColors.containerColor(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: GlobalColors.boxShadow(context),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_month, size: 20, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Text(
                'Call Frequency',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF101828),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 10,
              children: List.generate(
                CallFrequency.values.length,
                (index) => FrequencySelectionChip(
                  frequency: CallFrequency.values[index],
                  onTap: () => setState(
                    () => _selectedFrequency = CallFrequency.values[index],
                  ),
                  isSelected: _selectedFrequency == CallFrequency.values[index],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            height: 1,
            color: isDark ? Colors.grey[800] : const Color(0xFFEAECF0),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.notifications_active, size: 20, color: const Color(0xFFD68F00)),
              ),
              const SizedBox(width: 12),
              Text(
                'Priority Level',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: .spaceEvenly,
            children: CallPriority.values
                .map(
                  (priority) => PrioritySectionContainer(
                    priority: priority,
                    isSelected: _selectedPriority == priority,
                    onTap: () => setState(() => _selectedPriority = priority),
                  ),
                ).toList(),
          ),
        ],
      ),
    );
  }
}