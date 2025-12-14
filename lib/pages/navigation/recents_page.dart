import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/call_log/data/call_log_model.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_event.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/call_log/presentation/widgets/call_log_item.dart';

import 'package:vivapro/core/theme/global_colors.dart';
import 'package:call_log/call_log.dart';
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

    for (var log in logs) {
      final date = log.date;
      final logDay = DateTime(date.year, date.month, date.day);

      String key;
      if (logDay == today) {
        key = 'Today';
      } else if (logDay == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMMM d').format(date);
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
    return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA), // Light grey background
        appBar: AppBar(
          title: const Text('Recents'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<CallLogBloc, CallLogState>(
          builder: (context, state) {
            if (state is CallLogLoading) {
              return Center(child: LoadingAnimationWidget.threeRotatingDots(color: GlobalColors.darkPurple, size: 50));
            } else if (state is CallLogFailure) {
              return Center(child: Text(state.message));
            } else if (state is CallLogSuccess) {
              final groupedLogs = _groupLogsByDate(state.callLogEntries);
              final keys = groupedLogs.keys.toList();

              if (groupedLogs.isEmpty) {
                return const Center(child: Text('No recent calls'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: keys.length,
                itemBuilder: (context, index) {
                  final key = keys[index];
                  final logs = groupedLogs[key]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
                        child: Text(
                          key,
                          style: TextStyle(
                            color: Colors.blueGrey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          children: logs.asMap().entries.map((entry) {
                            final i = entry.key;
                            final log = entry.value;
                            return Column(
                              children: [
                                CallLogItem(entry: log),
                                if (i < logs.length - 1)
                                  Divider(
                                    height: 1,
                                    indent: 70, 
                                    endIndent: 0, 
                                    color: Colors.grey[100],
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                },
              );
            } 
            return const SizedBox.shrink();
          },
        ),
    );
  }
}
