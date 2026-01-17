import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/extensions/first_name_extension.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/features/auth/data/auth_user.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_bloc.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_state.dart';
import 'package:vivapro/features/call_log/presentation/bloc/call_log_event.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
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

    return Scaffold(
      extendBody: true,
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
              color: Theme.of(context).scaffoldBackgroundColor,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // People to Call Today Section
              _buildPeopleToCallToday(),
              const SizedBox(height: 32),
              
              // Insights Section
              InsightsSection(),
              const SizedBox(height: 32),
              
              // Favorites Section
              FavoritesSection(),
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

  Widget _buildPeopleToCallToday() {
    final peopleToCallAsync = ref.watch(peopleToCallTodayProvider);

    return peopleToCallAsync.when(
      data: (peopleToCall) {
        if (peopleToCall.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'People to Call Today',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...peopleToCall.take(3).map((contact) {
              return _buildCallTodayCard(contact);
            }),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCallTodayCard(FavoriteContact contact) {
    final interactionTracker = ref.read(interactionTrackerProvider);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: contact.contactDetails.photo != null
                ? MemoryImage(contact.contactDetails.photo!)
                : null,
            child: contact.contactDetails.photo == null
                ? Text(
                    contact.contactDetails.displayName.isNotEmpty
                        ? contact.contactDetails.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.contactDetails.displayName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getCallTodayMessage(contact),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final phoneNumber = contact.contactDetails.phones.isNotEmpty
                  ? contact.contactDetails.phones.first.number
                  : null;
              
              if (phoneNumber != null) {
                // Record the interaction
                if (contact.id != null) {
                  await interactionTracker.recordInteraction(contact.id!);
                }
                
                // Open phone dialer
                final uri = Uri(scheme: 'tel', path: phoneNumber);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  String _getCallTodayMessage(FavoriteContact contact) {
    if (contact.lastInteractionAt == null) {
      return 'You haven\'t called yet';
    }
    
    final daysSince = DateTime.now().difference(contact.lastInteractionAt!).inDays;
    if (daysSince == 0) {
      return 'Called today';
    } else if (daysSince == 1) {
      return 'Called yesterday';
    } else {
      return 'Called $daysSince days ago';
    }
  }
}
