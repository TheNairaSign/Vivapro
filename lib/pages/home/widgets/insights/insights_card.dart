import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_call_page.dart';

class InsightsCard extends ConsumerWidget {
  const InsightsCard({super.key, required this.insight});
  final ContactInsight insight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interactionTracker = ref.read(interactionTrackerProvider);
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
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
                        style: theme.textTheme.bodySmall?.copyWith(
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
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.3,
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

                              if (phoneNumber != null) {
                                // Record the interaction
                                await interactionTracker.recordInteraction(insight.contact.id);

                                // Open phone dialer
                                final uri = Uri(scheme: 'tel', path: phoneNumber);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: .15),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: Text(
                              'Call Now',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScheduleCallPage(
                                    contact: insight.contact.contactDetails,
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: .3)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: Text(
                              'Remind later',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
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
                      image: AssetImage('assets/images/insight_placeholder.png'),
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