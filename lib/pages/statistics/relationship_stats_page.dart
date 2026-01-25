import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/app_constants.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/repositories/contact_repository.dart';
import 'package:vivapro/pages/statistics/widgets/health_card.dart';
import 'package:vivapro/pages/statistics/widgets/period_selector_chips.dart';
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
  String _selectedFilter = 'Weekly'; 

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _fetchTotalContacts();
    context.read<ActivityBloc>().add(LoadActivities());
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
    
    // Get favorites to calculate period-based health
    final favoritesAsync = ref.watch(favoriteCacheServiceProvider).watchFavorites();
    
    return StreamBuilder<List<FavoriteContact>>(
      stream: favoritesAsync,
      builder: (context, favoritesSnapshot) {
        final favorites = favoritesSnapshot.data ?? [];
        
        return BlocBuilder<ActivityBloc, ActivityState>(
          builder: (context, activityState) {
            final activities = activityState is ActivityLoaded ? activityState.activities : <ActivityLog>[];
            
            final healthPercentage = _calculateHealthForPeriod(favorites, activities, _selectedFilter);
            final healthColor = _getHealthColor(healthPercentage);

            return Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Relationship Stats',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
                  physics: const BouncingScrollPhysics(),
                  padding: AppConstants.padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PeriodSelectorChips(
                        selectedPeriod: _selectedFilter,
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value;
                          });
                        },
                      ),

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
                        '$_selectedFilter Activity',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      if (activityState is ActivityLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        WeeklyActivityChart(logs: activities),
                      
                      // const SizedBox(height: 32),
                      
                      // Text(
                      //   'Activity Summary',
                      //   style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      // ),

                      // const SizedBox(height: 16),
                      
                      // SummarySection(activities, initialFilter: _selectedFilter),

                      const SizedBox(height: 100), // Bottom padding for nav bar
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  int _calculateHealthForPeriod(List<FavoriteContact> favorites, List<ActivityLog> activities, String filter) {
    if (favorites.isEmpty) return 100;

    final now = DateTime.now();
    int periodDays = 7;
    if (filter == 'Daily') periodDays = 1;
    if (filter == 'Monthly') periodDays = 30;

    final startDate = now.subtract(Duration(days: periodDays));
    
    double totalHealthScore = 0;

    for (final favorite in favorites) {
      final favoriteActivities = activities.where((a) => 
        a.contactId == favorite.id && 
        a.timestamp.isAfter(startDate)
      ).toList();

      final targetDays = _getTargetDaysForFrequency(favorite.callFrequency);
      final expectedInteractions = (periodDays / targetDays).clamp(1.0, double.infinity);
      
      final actualInteractions = favoriteActivities.length;
      
      double favoriteScore = (actualInteractions / expectedInteractions).clamp(0.0, 1.0);
      
      totalHealthScore += favoriteScore;
    }

    return ((totalHealthScore / favorites.length) * 100).round();
  }

  int _getTargetDaysForFrequency(CallFrequency frequency) {
    switch (frequency) {
      case CallFrequency.daily: return 1;
      case CallFrequency.weekly: return 7;
      case CallFrequency.monthly: return 30;
      case CallFrequency.yearly: return 365;
      case CallFrequency.custom: return 7;
    }
  }

  Color _getHealthColor(int health) {
    if (health >= 90) return Theme.of(context).colorScheme.primary;
    if (health >= 70) return const Color(0xFF4CAF50);
    if (health >= 50) return const Color(0xFFFFC107);
    if (health >= 30) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}
