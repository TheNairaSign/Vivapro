import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/core/extensions/first_name_extension.dart';
import 'package:vivapro/features/auth/data/auth_user.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_event.dart';
import 'package:vivapro/pages/home/widgets/favorites_section.dart';
import 'package:vivapro/pages/home/widgets/insights/insights_section.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/pages/home/widgets/people_to_call_section.dart';
import 'package:vivapro/pages/home/widgets/upcoming_reminders_section.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/scheduled_calendar_page.dart';

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
    context.read<ScheduleCallBloc>().add(ScheduleCallFetch());
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateString = DateFormat('EEEE, MMM d').format(now);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 15),
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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScheduledCalendarPage()),
              );
            }, 
            icon: const Icon(EvaIcons.calendarOutline, size: 20,)
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'SOS',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            spacing: 32,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
