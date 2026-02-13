import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/pages/home/widgets/feature_tip_card.dart';
import 'package:vivapro/pages/home/widgets/people_to_call_card.dart';

class PeopleToCallSection extends ConsumerStatefulWidget {
  const PeopleToCallSection({super.key});

  @override
  ConsumerState<PeopleToCallSection> createState() => _PeopleToCallSectionState();
}

class _PeopleToCallSectionState extends ConsumerState<PeopleToCallSection> {
  bool _showTip = true;

  @override
  Widget build(BuildContext context) {
    final peopleToCallAsync = ref.watch(peopleToCallTodayProvider);

    return peopleToCallAsync.when(
      data: (peopleToCall) {
        if (peopleToCall.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showTip)
              FeatureTipCard(onDismiss: () => setState(() => _showTip = false)),
            Text(
              'People to Call Today',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...peopleToCall.take(3).map((contact) {
              return PeopleToCallCard(contact: contact);
            }),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

}
