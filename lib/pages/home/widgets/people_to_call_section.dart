import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';

class PeopleToCallSection extends ConsumerWidget {
  const PeopleToCallSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...peopleToCall.take(3).map((contact) {
              return _buildCallTodayCard(context, ref, contact);
            }),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildCallTodayCard(BuildContext context, WidgetRef ref, FavoriteContact contact) {
    final interactionTracker = ref.read(interactionTrackerProvider);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(
        //   color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        //   width: 1,
        // ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            backgroundImage: contact.contactDetails.photo != null
                ? MemoryImage(contact.contactDetails.photo!)
                : null,
            child: contact.contactDetails.photo == null
              ? Text(
                  contact.contactDetails.displayName.isNotEmpty
                      ? contact.contactDetails.displayName[0].toUpperCase()
                      : '?',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  _getCallTodayMessage(contact),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
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
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Call', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
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
