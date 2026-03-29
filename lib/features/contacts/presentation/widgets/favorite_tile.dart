import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/services/interaction_tracker.dart';
import 'package:vivapro/core/services/pending_call_service.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/extensions/capitalization.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_avatar.dart';

class FavoriteTile extends ConsumerWidget {
  final FavoriteContact favoriteContact;
  final CallFrequency frequency;
  final bool isStarred;

  const FavoriteTile({
    super.key,
    required this.favoriteContact,
    required this.frequency,
    this.isStarred = false,
  });

  Color? get freqencyColor {
    return switch (frequency) {
      CallFrequency.daily => Colors.blue[700],
      CallFrequency.weekly => Colors.green,
      CallFrequency.monthly => Colors.purple,
      CallFrequency.yearly || CallFrequency.custom => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = favoriteContact.contactDetails;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          FavoriteAvatar(favorite: favoriteContact),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.displayName ?? 'John Doe',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: freqencyColor?.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: freqencyColor?.withValues(alpha: 0.1) ?? Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.repeat_rounded,
                        size: 12,
                        color: freqencyColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        frequency.name.capitalize(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: freqencyColor,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ref.read(favoriteCacheServiceProvider).toggleFavorite(isStarred, contact);
            },
            style: IconButton.styleFrom(
              backgroundColor: Colors.amber.withValues(alpha: 0.1),
            ),
            icon: Icon(
              isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
              color: Colors.amber,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () async {
                final interactionTracker = ref.read(interactionTrackerProvider);
                final phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : null;
                
                if (phoneNumber != null && contact.id != null) {
                  final activityId = await interactionTracker.recordInteraction(contact.id!);
                  await PendingCallService().setPendingCall(contact.id!, activityId: activityId);
                  
                  final uri = Uri(scheme: 'tel', path: phoneNumber);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.phone_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
