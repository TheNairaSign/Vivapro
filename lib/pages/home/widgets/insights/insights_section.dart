import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/pages/home/widgets/calls_planned_container.dart';
import 'package:vivapro/pages/home/widgets/insights/empty_insight_card.dart';
import 'package:vivapro/pages/home/widgets/insights/insights_card.dart';
import 'package:vivapro/pages/home/widgets/relationship_health_container.dart';

class InsightsSection extends ConsumerWidget {
  const InsightsSection({super.key});
  
  /*
  Color getHealthColor(int health, BuildContext context) {
    if (health == 100) return Theme.of(context).colorScheme.primary;
    if (health > 80) return const Color(0xFF4CAF50);
    if (health > 60) return const Color(0xFFFFC107);
    if (health > 40) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
  */

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(insightsStreamProvider);
    
    // final insights = insightsAsync.asData?.value ?? [];
    // final healthPercentage = _calculateRelationshipHealth(insights);
    // final healthColor = getHealthColor(healthPercentage, context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(
          'Insights',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),

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
        
        Row(
          children: [
            Expanded(child: RelationshipHealthContainer()),
            const SizedBox(width: 16),
            Expanded(child: CallsPlannedContainer()),
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

  /*

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
  */
}

