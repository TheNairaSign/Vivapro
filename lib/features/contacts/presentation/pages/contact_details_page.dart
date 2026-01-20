import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/widgets/contact_details/contact_action_buttons.dart';
import 'package:vivapro/features/contacts/presentation/widgets/contact_details/contact_history_section.dart';
import 'package:vivapro/features/contacts/presentation/widgets/contact_details/contact_profile_header.dart';
import 'package:vivapro/features/contacts/presentation/widgets/contact_details/contact_relationship_health.dart';
import 'package:vivapro/features/contacts/presentation/widgets/contact_details/contact_settings_list.dart';

class ContactDetailsPage extends ConsumerStatefulWidget {
  final Contact contact;
  final FavoriteContact? favoriteContact;
  const ContactDetailsPage(this.contact, {super.key, this.favoriteContact});

  @override
  ConsumerState<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends ConsumerState<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Watch if this contact is a favorite
    final favoritesAsync = ref.watch(favoritesStreamProvider);
    
    FavoriteContact? currentFavorite = widget.favoriteContact;
    
    // If we don't have the favorite contact passed in, find it in the list
    if (currentFavorite == null) {
      favoritesAsync.whenData((favorites) {
        try {
          currentFavorite = favorites.firstWhere((f) => f.id == widget.contact.id);
        } catch (_) {
          currentFavorite = null;
        }
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Edit functionality
            },
            child: Text(
              'Edit',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          ContactProfileHeader(contact: widget.contact),
          const SizedBox(height: 30),
          ContactActionButtons(contact: widget.contact),
          const SizedBox(height: 30),
          if (currentFavorite != null) ...[
            ContactRelationshipHealth(favorite: currentFavorite!),
            const SizedBox(height: 30),
          ],
          ContactSettingsList(),
          const SizedBox(height: 30),
          ContactHistorySection(contact: widget.contact, favorite: currentFavorite),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// Stream provider for favorites if not already defined
final favoritesStreamProvider = StreamProvider<List<FavoriteContact>>((ref) {
  return ref.watch(favoriteCacheServiceProvider).watchFavorites();
});
