import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/repositories/schedule_call_repository.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/scheduled_calls_page.dart';

class InsightsSection extends ConsumerWidget {
  const InsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(insightsStreamProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insights',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        
        // Main insight card
        insightsAsync.when(
          data: (insights) {
            if (insights.isEmpty) {
              return _buildEmptyInsightCard(context);
            }
            return _buildInsightCard(context, ref, insights.first);
          },
          loading: () => _buildLoadingCard(context),
          error: (_, __) => _buildEmptyInsightCard(context),
        ),
        
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 140,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: .25),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Icon(
                        EvaIcons.peopleOutline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    insightsAsync.when(
                      data: (insights) {
                        final healthPercentage = _calculateRelationshipHealth(insights);
                        return Text(
                          '$healthPercentage%',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                      loading: () => Text(
                        '--',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      error: (_, __) => Text(
                        '--',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Relationship Health',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CallsPlannedContainer(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightCard(BuildContext context, WidgetRef ref, ContactInsight insight) {
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: .15),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: Text(
                              'Call Now',
                              style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
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
                              final repo = ref.read(scheduleCallRepositoryProvider);
                              final now = DateTime.now();
                              final tomorrow = DateTime(now.year, now.month, now.day + 1, 10, 0);
                              
                              final call = ScheduleCall(
                                contact: insight.contact.contactDetails,
                                date: tomorrow,
                                time: const TimeOfDay(hour: 10, minute: 0),
                                note: 'Follow up from insight: ${insight.message}',
                              );
                              
                              await repo.scheduleCall(call);
                              
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Reminder set for tomorrow at 10:00 AM')),
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: .3),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: Text(
                              'Remind later',
                              style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
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
            flex: 2,
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

  Widget _buildEmptyInsightCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Colors.green[400],
            ),
            const SizedBox(height: 12),
            Text(
              'You\'re all caught up!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'No urgent calls needed',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  int _calculateRelationshipHealth(List<ContactInsight> insights) {
    if (insights.isEmpty) return 100;
    
    // Calculate based on priority distribution
    final highPriority = insights.where((i) => i.priority == InsightPriority.high).length;
    final mediumPriority = insights.where((i) => i.priority == InsightPriority.medium).length;
    
    // Simple formula: reduce health based on urgent insights
    final healthReduction = (highPriority * 20) + (mediumPriority * 10);
    final health = 100 - healthReduction;
    
    return health.clamp(0, 100);
  }
}


class CallsPlannedContainer extends StatefulWidget {
  const CallsPlannedContainer({super.key});

  @override
  State<CallsPlannedContainer> createState() => _CallsPlannedContainerState();
}

class _CallsPlannedContainerState extends State<CallsPlannedContainer> {
  int _plannedCalls = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScheduledCallsPage(),
          ),
        );
      },
      child: BlocListener<ScheduleCallBloc, ScheduleCallState>(
        listener: (context, state) {
          if (state is ScheduleCallLoaded) {
            setState(() {
              _plannedCalls = state.scheduleCalls.length;
            });
          }
        },
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 12),
              Text(
                '$_plannedCalls',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text('Calls planned', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

