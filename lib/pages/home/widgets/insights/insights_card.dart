import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/components/show_flushbar.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_use_case.dart';
import 'package:vivapro/features/schedule_call/repositories/schedule_call_repository.dart';

class InsightsCard extends ConsumerWidget {
  const InsightsCard({super.key, required this.insight});
  final ContactInsight insight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interactionTracker = ref.read(interactionTrackerProvider);

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.amber[600], size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'RECONNECT',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    insight.message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () async {
                              final phoneNumber = insight.contact.contactDetails.phones.isNotEmpty
                                  ? insight.contact.contactDetails.phones.first.number
                                  : null;

                              if (phoneNumber != null && insight.contact.id != null) {
                                // Record the interaction
                                await interactionTracker.recordInteraction(insight.contact.id!);

                                // Open phone dialer
                                final uri = Uri(scheme: 'tel', path: phoneNumber);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: .15),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: Text(
                              'Call Now',
                              style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context,).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: OutlinedButton(
                            onPressed: () async {
                              final usecase = ref.watch(scheduleCallUseCase);
                              final result = await usecase.setReminder(insight);
                              if (context.mounted && result) {
                                showFlushbar(context, 'Reminder set', 'Reminder set for tomorrow at 10:00 AM');
                              } else {
                                if (!context.mounted) return;
                                showFlushbar(context, 'Failed to set reminder', 'Failed to set reminder');
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6,),
                              side: BorderSide(color: Theme.of(context,).colorScheme.primary.withValues(alpha: .3),),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),),
                            ),
                            child: Text(
                              'Remind later',
                              style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                color: Colors.grey[800],
                image: insight.contact.contactDetails.photo != null
                  ? DecorationImage(
                      image: MemoryImage(insight.contact.contactDetails.photo!),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1590086782957-93c06ef21604?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
                      ),
                      fit: BoxFit.cover,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}