import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/call_log/data/call_log_model.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_event.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/contacts/presentation/pages/add_favorite_page.dart';
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
      backgroundColor: isDark ? const Color(0xFF101A22) : const Color(0xFFF4F7FA),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const AddFavoritePage()),
      //     );
      //   },
      //   backgroundColor: const Color(0xFF2D8CFF),
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activity',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your relationship log',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C3E) : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.tune, color: isDark ? Colors.white : Colors.black87, size: 20),
                    ),
                  ],
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
                          size: 30
                        )
                      ),
                    ),
                  );
                } else if (state is CallLogFailure) {
                  return SliverToBoxAdapter(child: Center(child: Text(state.message)));
                } else if (state is CallLogSuccess) {
                  final groupedLogs = _groupLogsByDate(state.callLogEntries);
                  final keys = groupedLogs.keys.toList();

                  // Ensure TODAY is first even if empty if we want to show Insight
                  if (!keys.contains('TODAY')) {
                    // Logic to just show basic "Active" state
                    // We can artificially insert Insight if list is empty?
                  }

                  if (groupedLogs.isEmpty) {
                     return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child:  InsightCard(),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final key = keys[index];
                        final logs = groupedLogs[key]!;
                        final isToday = key == 'TODAY';

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 24, bottom: 12),
                                child: Text(
                                  key,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              if (isToday) ...[
                                const InsightCard(),
                                const SizedBox(height: 12),
                              ],
                              ...logs.map((log) => ActivityItem(log: log)),
                            ],
                          ),
                        );
                      },
                      childCount: keys.length,
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
             const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}
