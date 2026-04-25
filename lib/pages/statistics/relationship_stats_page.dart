import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/app_constants.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/core/utils/relationship_health_utils.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/repositories/contact_repository.dart';
import 'package:vivapro/pages/statistics/widgets/health_card.dart';
import 'package:vivapro/pages/statistics/widgets/period_selector_chips.dart';
import 'package:vivapro/pages/statistics/widgets/stats_card.dart';
import 'package:vivapro/pages/statistics/widgets/activity_chart.dart';

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
            
            final healthPercentage = RelationshipHealthUtils.calculateHealthForPeriod(favorites, activities, _selectedFilter);
            final healthColor = RelationshipHealthUtils.getHealthColor(context, healthPercentage);

            return Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Relationship Stats',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
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

                      Hero(
                        tag: 'relationship_health',
                        // createRectTween: (begin, end) {
                        //   return Tween(
                        //     begin: Rect.fromLTWH(begin!.left, begin.top, begin.width, begin.height),
                        //     end: Rect.fromLTWH(end!.left, end.top, end.width, end.height),
                        //   );
                        // },
                        child: HealthCard(percentage: healthPercentage, color: healthColor)),

                      const SizedBox(height: 20),

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

                      const SizedBox(height: 20),

                      Text(
                        '$_selectedFilter Activity',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      if (activityState is ActivityLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        ActivityChart(logs: activities, period: _selectedFilter),
                      
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
}

  