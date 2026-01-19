import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/pages/home/widgets/calls_planned_container.dart';
import 'package:vivapro/pages/home/widgets/insights/empty_insight_card.dart';
import 'package:vivapro/pages/home/widgets/insights/insights_card.dart';

class InsightsSection extends ConsumerWidget {
  const InsightsSection({super.key});

  Color getHealthColor(int health, BuildContext context) {
    if (health == 100) return Theme.of(context).colorScheme.primary;
    if (health > 80) return const Color(0xFF4CAF50);
    if (health > 60) return const Color(0xFFFFC107);
    if (health > 40) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(insightsStreamProvider);
    
    final insights = insightsAsync.asData?.value ?? [];
    final healthPercentage = _calculateRelationshipHealth(insights);
    final healthColor = getHealthColor(healthPercentage, context);
    
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
              return EmptyInsightCard();
            }
            return InsightsCard(insight: insights.first);
          },
          loading: () => _buildLoadingCard(context),
          error: (_, _) => EmptyInsightCard(),
        ),
        
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 140,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: healthColor.withValues(alpha: 0.1),
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
                        color: healthColor,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$healthPercentage%',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: healthColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Relationship Health',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,),
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
