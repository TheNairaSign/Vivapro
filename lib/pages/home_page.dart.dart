import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_event.dart';
import 'package:vivapro/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/pages/home/widgets/favorites_section.dart';
import 'package:vivapro/pages/home/widgets/home_header.dart';
import 'package:vivapro/pages/home/widgets/insights_section.dart';
import 'package:vivapro/pages/home/widgets/recents_item.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<CallLogBloc>().add(GetCallLogs());
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateString = DateFormat('EEEE, MMM d').format(now);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 15),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateString,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Good evening, Ty',
              style: TextStyle(
                // color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark? const Color(0xFF1C2029): Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const .symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              FavoritesSection(),
              const SizedBox(height: 32),
              InsightsSection(),
              const SizedBox(height: 32),
              _buildRecentsList(),
              const SizedBox(height: 80), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentsList() {
    return BlocBuilder<CallLogBloc, CallLogState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        if (state is CallLogSuccess) {
          final logs = state.callLogEntries
              .take(3)
              .toList(); // Show limited recents for UI demo

          return Container(
            decoration: BoxDecoration(
              color: GlobalColors.containerColor(context),
              borderRadius: BorderRadius.circular(20),
              boxShadow: GlobalColors.boxShadow(context),
            ),
            // padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Column(
              children: logs.map((log) {
                return Column(
                  children: [
                    RecentsItem(log: log),
                    if (logs.indexOf(log) < logs.length - 1)
                      Divider(
                        height: 1,
                        indent: 10,
                        endIndent: 10,
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                      ),
                  ],
                );
              }).toList(),
            ),
          );
        } else if (state is CallLogLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2D8CFF)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
