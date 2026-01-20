import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/components/show_flushbar.dart';
import 'package:vivapro/core/services/insight_generator.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_use_case.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_call_page.dart';
import 'package:vivapro/pages/home/widgets/feature_tip_card.dart';
import 'package:vivapro/widgets/text_avatar.dart';

class PeopleToCallSection extends ConsumerStatefulWidget {
  const PeopleToCallSection({super.key});

  @override
  ConsumerState<PeopleToCallSection> createState() => _PeopleToCallSectionState();
}

class _PeopleToCallSectionState extends ConsumerState<PeopleToCallSection> {
  bool _showTip = true;

  @override
  Widget build(BuildContext context) {
    final peopleToCallAsync = ref.watch(peopleToCallTodayProvider);

    return peopleToCallAsync.when(
      data: (peopleToCall) {
        if (peopleToCall.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showTip)
              FeatureTipCard(
                onDismiss: () => setState(() => _showTip = false),
              ),
            Text(
              'People to Call Today',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...peopleToCall.take(3).map((contact) {
              return _buildCallTodayCard(context, contact);
            }),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildCallTodayCard(BuildContext context, FavoriteContact contact) {
    final interactionTracker = ref.read(interactionTrackerProvider);
    
    return InkWell(
      onLongPress: () async {
        // We need the position for the menu. Since onLongPress doesn't provide it directly,
        // we'll use a standard Material approach or approximate with a generic position.
        // For a more precise position, one would usually use a Gesture detector or GlobalKey.
        // For now, we'll center it relative to the context.
        
        final RenderBox button = context.findRenderObject() as RenderBox;
        final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset.zero, ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );
        
        final choice = await showMenu<String>(
          context: context,
          position: position,
          items: [
            const PopupMenuItem(
              value: 'tomorrow_10am',
              child: Text('Remind tomorrow at 10 AM'),
            ),
            const PopupMenuItem(
              value: 'tomorrow_evening',
              child: Text('Remind tomorrow evening (6 PM)'),
            ),
            const PopupMenuItem(
              value: 'custom',
              child: Text('Custom reminder...'),
            ),
          ],
        );

        if (choice == null || !context.mounted) return;

        DateTime? scheduledTime;
        final now = DateTime.now();

        if (choice == 'tomorrow_10am') {
          scheduledTime = DateTime(now.year, now.month, now.day + 1, 10, 0);
        } else if (choice == 'tomorrow_evening') {
          scheduledTime = DateTime(now.year, now.month, now.day + 1, 18, 0);
        } else if (choice == 'custom') {
          // Navigate to custom schedule page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleCallPage(
                contact: contact.contactDetails,
              ),
            ),
          );
          return;
        }

        if (scheduledTime != null) {
          final useCase = ref.watch(scheduleCallUseCase);
          final success = await useCase.setContactReminder(contact, scheduledTime);
          if (success && context.mounted) {
            showFlushbar(
              context, 
              'Reminder Set', 
              'Reminder set for ${contact.contactDetails.displayName} at ${scheduledTime.hour}:00',
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
           contact.contactDetails.photo != null ? CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF3E3E4A),
              backgroundImage: MemoryImage(contact.contactDetails.photo!),
            ) : TextAvatar(name: contact.contactDetails.displayName),
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
                  // Record the interaction
                  await interactionTracker.recordInteraction(contact.id);
                  
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
