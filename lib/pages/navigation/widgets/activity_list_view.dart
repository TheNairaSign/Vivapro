import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/pages/navigation/widgets/activity_item.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/core/app_constants.dart';

class ActivityListView extends StatelessWidget {
  final ActivityType? selectedFilter;

  const ActivityListView({
    super.key,
    this.selectedFilter,
  });

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

  List<ActivityLog> _getFilteredActivities(List<ActivityLog> activities) {
    if (selectedFilter == null) {
      return activities;
    }
    return activities.where((log) => log.type == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        if (state is ActivityLoading) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  // color: const Color(0xFF2D8CFF),
                  color: Theme.of(context).colorScheme.primary,
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
          final filteredActivities = _getFilteredActivities(state.activities);
          final groupedLogs = _groupLogsByDate(filteredActivities);
          final keys = groupedLogs.keys.toList();

          if (groupedLogs.isEmpty) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.padding.left),
                child: Center(child: Text("No recent activity.")),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final key = keys[index];
              final logs = groupedLogs[key]!;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.padding.left),
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
    );
  }
}