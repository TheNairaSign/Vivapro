import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/features/call_log/data/call_log_model.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_event.dart';
import 'package:vivapro/pages/navigation/widgets/activity_item.dart';
import 'package:vivapro/pages/navigation/widgets/filter_pills.dart';
import 'package:vivapro/pages/navigation/widgets/insight_card.dart';

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
    context.read<CallLogBloc>().add(GetCallLogs());
  }

  Map<String, List<CallLogModel>> _groupLogsByDate(List<CallLogModel> logs) {
    final groups = <String, List<CallLogModel>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // Sort descending by timestamp
    final sortedLogs = List<CallLogModel>.from(logs);
    sortedLogs.sort((a, b) => (b.timestamp ?? 0).compareTo(a.timestamp ?? 0));

    for (var log in sortedLogs) {
      final date = log.date;
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final contact = await Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const ContactPickerPage()),
      //     );
      //     if (contact != null && context.mounted) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => AddFavoritePage(contact: contact),
      //         ),
      //       );
      //     }
      //   },
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activity',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF1A1D1E),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
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
      
          // Insight Card (Only visible if Today has items or just hardcoded for demo)
          // In the design, it's under "TODAY" section or just at the top?
          // "TODAY" header is above the insight card in the image.
      
          // We'll put Insight Card inside the list or just as a static item at the top of Today for now.
          // Let's verify the image structure:
          // "TODAY" -> Insight Card -> Sarah Item -> Dad Item.
          BlocBuilder<CallLogBloc, CallLogState>(
            builder: (context, state) {
              if (state is CallLogLoading) {
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
              } else if (state is CallLogFailure) {
                return SliverToBoxAdapter(
                  child: Center(child: Text(state.message)),
                );
              } else if (state is CallLogSuccess) {
                final groupedLogs = _groupLogsByDate(state.callLogEntries);
                final keys = groupedLogs.keys.toList();
                final insights = state.insights;
      
                if (groupedLogs.isEmpty && insights.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text("No recent activity.")),
                    ),
                  );
                }
      
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    // This is a bit of a hack to combine two lists (insights and logs)
                    // A better approach would be a single list of a sealed type.
                    // For now, we render insights first, then the log groups.
      
                    if (index == 0 && insights.isNotEmpty) {
                      // Render Insights Section
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
                                '✨ SMART INSIGHTS',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500],
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                             InsightCard(insight: insights.first),
                          ],
                        ),
                      );
                    }
      
                    // Adjust index for logs
                    final logIndex = insights.isNotEmpty ? index - 1 : index;
                    if (logIndex < 0 || logIndex >= keys.length) {
                      return const SizedBox.shrink();
                    }
      
                    final key = keys[logIndex];
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
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                  }, childCount: keys.length + (insights.isNotEmpty ? 1 : 0)),
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
