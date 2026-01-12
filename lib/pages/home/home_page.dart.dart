import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/core/extensions/first_name_extension.dart';
import 'package:vivapro/features/auth/data/auth_user.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_event.dart';
import 'package:vivapro/pages/home/widgets/favorites_section.dart';
import 'package:vivapro/pages/home/widgets/insights_section.dart';
import 'package:vivapro/pages/home/widgets/recents_item.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage(this.user, {super.key});
  final AuthUser user;

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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Good evening, ${widget.user.displayName?.firstName}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C2029) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  'SOS',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red,
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
        if (state is CallLogSuccess) {
          final logs = state.callLogEntries.take(3).toList();

          return Column(
            children: logs.map((log) => RecentsItem(log: log)).toList(),
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
