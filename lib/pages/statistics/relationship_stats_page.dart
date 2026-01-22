
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/features/contacts/repositories/contact_repository.dart';
import 'package:vivapro/pages/statistics/widgets/health_card.dart';
import 'package:vivapro/pages/statistics/widgets/stats_card.dart';
import 'package:vivapro/pages/statistics/widgets/summary_section.dart';
import 'package:vivapro/pages/statistics/widgets/weekly_activity_chart.dart';

class RelationshipStatsPage extends ConsumerStatefulWidget {
 const RelationshipStatsPage({super.key});

  @override
  ConsumerState<RelationshipStatsPage> createState() => _RelationshipStatsPageState();
}

class _RelationshipStatsPageState extends ConsumerState<RelationshipStatsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _totalContacts = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _fetchTotalContacts();
  }

  Future<void> _fetchTotalContacts() async {
    try {
      final contacts = await ref.read(contactsRepository).getContacts();
      if (mounted) {
        setState(() {
          _totalContacts = contacts.length;
        });
      }
    } catch (e) {
      debugPrint('Error fetching contact count: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final insightsAsync = ref.watch(insightsStreamProvider);
    final insights = insightsAsync.asData?.value ?? [];
    final healthPercentage = _calculateRelationshipHealth(insights);
    final healthColor = _getHealthColor(healthPercentage);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Relationship Stats',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Your relationship progress',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HealthCard(percentage: healthPercentage, color: healthColor),

              const SizedBox(height: 24),

              // Stats Grid
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      title: 'Total Contacts',
                      value: _totalContacts.toString(),
                      icon: EvaIcons.peopleOutline,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatsCard(
                      title: 'Highlights',
                      value: insights.length.toString(),
                      icon: EvaIcons.starOutline,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                'Weekly Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              BlocBuilder<CallLogBloc, CallLogState>(
                builder: (context, state) {
                  if (state is CallLogSuccess) {
                    return WeeklyActivityChart(logs: state.callLogEntries);
                  } else if (state is CallLogLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    alignment: Alignment.center,
                    child: const Text('No data available'),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'Activity Summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              BlocBuilder<CallLogBloc, CallLogState>(
                builder: (context, state) {
                  if (state is CallLogSuccess) {
                    return SummarySection(state.callLogEntries);
                  } else if (state is CallLogLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 100), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  // Copied from InsightsSection to maintain consistency
  int _calculateRelationshipHealth(List<ContactInsight> insights) {
    if (insights.isEmpty) return 100;

    final highPriority = insights.where((i) => i.priority == InsightPriority.high).length;
    final mediumPriority = insights.where((i) => i.priority == InsightPriority.medium).length;

    final healthReduction = (highPriority * 20) + (mediumPriority * 10);
    final health = 100 - healthReduction;

    return health.clamp(0, 100);
  }

  Color _getHealthColor(int health) {
    if (health == 100) return Theme.of(context).colorScheme.primary;
    if (health > 80) return const Color(0xFF4CAF50);
    if (health > 60) return const Color(0xFFFFC107);
    if (health > 40) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}
