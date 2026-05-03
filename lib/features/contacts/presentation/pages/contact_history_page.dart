import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/models/contact/contact.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/features/activity/presentation/widgets/activity_log_item.dart';
import 'package:vivapro/widgets/custom_back_button.dart';

class ContactHistoryPage extends StatelessWidget {
  final Contact contact;

  const ContactHistoryPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          'Call History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          if (state is ActivityLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ActivityLoaded) {
            final contactActivities = state.activities
                .where((log) => log.contactId == contact.id)
                .toList()
              ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

            if (contactActivities.isEmpty) {
              return _buildEmptyState(context);
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
              itemCount: contactActivities.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 60,
                color: isDark ? Colors.grey[800] : Colors.grey[100],
              ),
              itemBuilder: (context, index) {
                return ActivityLogItem(
                  log: contactActivities[index],
                  showChevron: false,
                );
              },
            );
          }

          return _buildEmptyState(context);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Ionicons.time_outline, size: 48, color: Colors.grey[400]),
          ),
          const SizedBox(height: 20),
          Text(
            'No history found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Interaction logs for ${contact.displayName} will appear here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }
}
