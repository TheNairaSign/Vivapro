import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/pages/contact_details_page.dart';
import 'package:vivapro/core/extensions/first_name_extension.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_avatar.dart';
import 'package:vivapro/core/utils/call_modal.dart';

class FavoritesCard extends ConsumerWidget {
  const FavoritesCard({super.key, required this.contact});
  final FavoriteContact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ContactDetailsPage(contact.contactDetails),
        ),
      ),
      child: SizedBox(
        width: 170,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                   Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: FavoriteAvatar(favorite: contact, radius: 30),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                (contact.contactDetails.displayName ?? 'John Doe').capitalizeFirst,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Last called: ${contact.lastInteractionAt != null ? _formatLastInteraction(contact.lastInteractionAt!) : 'Never'}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed: () async {
                    final phoneNumber = contact.contactDetails.phones.isNotEmpty
                        ? contact.contactDetails.phones.first.number
                        : null;
                    
                    if (phoneNumber != null) {
                      showCallOptionsModal(
                        context: context,
                        ref: ref,
                        phoneNumber: phoneNumber,
                        contactId: contact.id,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                  child: Text(
                    'Call now',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatLastInteraction(DateTime lastInteraction) {
    final now = DateTime.now();
    final difference = now.difference(lastInteraction);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
