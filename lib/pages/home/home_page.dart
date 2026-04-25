import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/core/app_constants.dart';
import 'package:vivapro/core/utils/format_date.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/features/call_reminder/presentation/providers/call_reminder_provider.dart';
import 'package:vivapro/pages/home/widgets/favorites_section.dart';
import 'package:vivapro/pages/home/widgets/insights/insights_section.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/pages/home/widgets/people_to_call_section.dart';
import 'package:vivapro/pages/home/widgets/upcoming_reminders_section.dart';
import 'package:vivapro/features/call_reminder/presentation/widgets/call_reminder_banner.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/scheduled_calendar_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ActivityBloc>().add(LoadActivities());
    context.read<ScheduleCallBloc>().add(ScheduleCallFetch());
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 16) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final dateString = DateFormat('EEEE, MMM d').format(now) + now.daySuffix;

    final state = ref.watch(callReminderBannerProvider);
    final call = state.activeCall;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 5),
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
              _getGreeting(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          BlocBuilder<ScheduleCallBloc, ScheduleCallState>(
            builder: (context, state) {
              if (state is ScheduleCallLoaded) {
                final now = DateTime.now();
                final upcomingCount = state.scheduleCalls.where((call) {
                  final callDateTime = DateTime(
                    call.date.year,
                    call.date.month,
                    call.date.day,
                    call.time.hour,
                    call.time.minute,
                  );
                  return callDateTime.isAfter(now) || callDateTime.isAfter(now.subtract(const Duration(hours: 24)));
                }).length;

                if (upcomingCount > 0) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isDark ? EvaIcons.bellOutline : EvaIcons.bell,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$upcomingCount',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScheduledCalendarPage()),
              );
            }, 
            icon: const Icon(EvaIcons.calendarOutline, size: 20,)
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: AppConstants.padding,
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (call != null) ...[
                // const SizedBox(height: 10),
                CallReminderBanner()
              ],
              // CustomBanner(),
              PeopleToCallSection(),
              InsightsSection(),
              FavoritesSection(),
              UpcomingRemindersSection(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
