import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivapro/features/contacts/data/add_favorites_provider.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorites/frequency_selection_chip.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorites/priority_section_container.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/enums/priority.dart';

class FrequencyContainer extends StatefulWidget {
  const FrequencyContainer({super.key});

  @override
  State<FrequencyContainer> createState() => _FrequencyContainerState();
}

class _FrequencyContainerState extends State<FrequencyContainer> {

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<AddFavoritesProvider>(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        border: null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(EvaIcons.calendarOutline, size: 22, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Text(
                'Call Frequency',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              spacing: 12,
              children: List.generate(
                CallFrequency.values.length,
                (index) => FrequencySelectionChip(
                  frequency: CallFrequency.values[index],
                  onTap: () => favoritesProvider.updateCallFrequency(CallFrequency.values[index]),
                  isSelected: favoritesProvider.callFrequency == CallFrequency.values[index],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF2F4F7),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFE0A0).withValues(alpha: 0.3), width: 1),
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  size: 22,
                  color: Color(0xFFD68F00),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Priority Level',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF101828),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: CallPriority.values
                .map(
                  (priority) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: priority == CallPriority.values.last ? 0 : 12,
                      ),
                      child: PrioritySectionContainer(
                        priority: priority,
                        isSelected: favoritesProvider.callPriority == priority,
                        onTap: () => favoritesProvider.updateCallPriority(priority),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
