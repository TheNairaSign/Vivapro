
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/features/call_log/data/call_log_model.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/features/contacts/repositories/contact_repository.dart';

class RelationshipStatsPage extends ConsumerStatefulWidget {
  const RelationshipStatsPage({super.key});

  @override
  ConsumerState<RelationshipStatsPage> createState() =>
      _RelationshipStatsPageState();
}

class _RelationshipStatsPageState extends ConsumerState<RelationshipStatsPage>
    with SingleTickerProviderStateMixin {
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
            const SizedBox(height: 8),
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
              // Main Health Card
              _buildHealthCard(healthPercentage, healthColor),

              const SizedBox(height: 24),

              // Stats Grid
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Contacts',
                      _totalContacts.toString(),
                      EvaIcons.peopleOutline,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Highlights',
                      insights.length.toString(),
                      EvaIcons.starOutline,
                      Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                'Weekly Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Charts
              BlocBuilder<CallLogBloc, CallLogState>(
                builder: (context, state) {
                  if (state is CallLogSuccess) {
                    return _buildWeeklyChart(state.callLogEntries);
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
              
              const SizedBox(height: 100), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthCard(int percentage, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.8),
            color.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Relationship Health',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$percentage%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  EvaIcons.heart,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(999),
              value: percentage / 100,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            percentage > 80
                ? 'Great job keeping in touch!'
                : 'Time to reconnect with some friends.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(List<CallLogModel> logs) {
    // Process logs to get counts per day for the last 7 days
    final now = DateTime.now();
    final weekDays = List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return day;
    });

    final counts = weekDays.map((day) {
      return logs.where((log) {
        final logDate = log.date;
        return logDate.year == day.year &&
            logDate.month == day.month &&
            logDate.day == day.day;
      }).length;
    }).toList();

    final maxCount = counts.isEmpty ? 1 : counts.reduce((a, b) => a > b ? a : b);
    final displayMax = maxCount == 0 ? 1 : maxCount;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
            BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calls',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${counts.fold(0, (a, b) => a + b)} this week',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final count = counts[index];
              final heightFactor = count / displayMax;
              // Format day name (e.g., 'Mon')
              final dayName = _getDayName(weekDays[index].weekday);

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: heightFactor),
                    duration: Duration(milliseconds: 500 + (index * 100)),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Container(
                        width: 12,
                        height: 100 * value + 10, // Minimum height of 10
                        decoration: BoxDecoration(
                          color: index == 6 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dayName,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // Copied from InsightsSection to maintain consistency
  int _calculateRelationshipHealth(List<ContactInsight> insights) {
    if (insights.isEmpty) return 100;

    final highPriority =
        insights.where((i) => i.priority == InsightPriority.high).length;
    final mediumPriority =
        insights.where((i) => i.priority == InsightPriority.medium).length;

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
