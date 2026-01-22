import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/pages/navigation/widgets/activity_item.dart';
import 'package:vivapro/pages/navigation/widgets/filter_pills.dart';
import 'package:intl/intl.dart';

class RecentsPage extends StatefulWidget {
  const RecentsPage({super.key});

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ActivityBloc>().add(LoadActivities());
  }

  Map<String, List<ActivityLog>> _groupLogsByDate(List<ActivityLog> logs) {
    final groups = <String, List<ActivityLog>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Sort descending by timestamp
    final sortedLogs = List<ActivityLog>.from(logs);
    sortedLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    for (var log in sortedLogs) {
      final date = log.timestamp;
      final logDay = DateTime(date.year, date.month, date.day);

      String key;
      if (logDay == today) {
        key = 'TODAY';
      } else if (logDay == yesterday) {
        key = 'YESTERDAY';
      } else {
        key = DateFormat('MMMM d').format(date).toUpperCase();
      }

      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(log);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your relationship log',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                ),
              ],
            ),
            floating: true,
            pinned: true,
            actions: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C3E) : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.tune,
                  color: isDark ? Colors.white : Colors.black87,
                  size: 20,
                ),
              ),
            ],
          ),
          // Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
            ),
          ),

          // Filter Pills
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: FilterPills(),
            ),
          ),

          BlocBuilder<ActivityBloc, ActivityState>(
            builder: (context, state) {
              if (state is ActivityLoading) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: const Color(0xFF2D8CFF),
                        size: 30,
                      ),
                    ),
                  ),
                );
              } else if (state is ActivityError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text(state.message)),
                );
              } else if (state is ActivityLoaded) {
                final groupedLogs = _groupLogsByDate(state.activities);
                final keys = groupedLogs.keys.toList();

                if (groupedLogs.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text("No recent activity.")),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final key = keys[index];
                    final logs = groupedLogs[key]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 24,
                              bottom: 12,
                            ),
                            child: Text(
                              key,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                    letterSpacing: 1.2,
                                  ),
                            ),
                          ),
                          ...logs.map((log) => ActivityItem(log: log)),
                        ],
                      ),
                    );
                  }, childCount: keys.length),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}
