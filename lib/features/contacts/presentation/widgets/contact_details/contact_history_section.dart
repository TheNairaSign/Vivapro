import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/models/contact/contact.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/features/activity/presentation/widgets/activity_log_item.dart';
import 'package:vivapro/features/contacts/presentation/pages/contact_history_page.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';

class ContactHistorySection extends StatelessWidget {
  final Contact contact;
  final FavoriteContact? favorite;

  const ContactHistorySection({super.key, required this.contact, this.favorite});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent History',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ContactHistoryPage(contact: contact),
                  ),
                );
              },
              child: Text(
                'View All',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<ActivityBloc, ActivityState>(
          builder: (context, state) {
            if (state is ActivityLoaded) {
              // Filter activities for this contact
              final contactActivities = state.activities
                .where((log) {
                  return log.contactId == contact.id;
                })
                .take(2)
                .toList();

              if (contactActivities.isEmpty) {
                return _buildEmptyHistory(context);
              }

              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: contactActivities.asMap().entries.map((entry) {
                    final index = entry.key;
                    final log = entry.value;
                    return Column(
                      children: [
                        ActivityLogItem(log: log),
                        if (index < contactActivities.length - 1)
                          Divider(
                            height: 1,
                            indent: 74,
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                          ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
            return _buildEmptyHistory(context);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyHistory(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(Ionicons.call_outline, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No recent activity',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }


  }

