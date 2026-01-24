import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/pages/add_favorite_page.dart';
import 'package:vivapro/features/contacts/presentation/pages/favorites_page.dart';
import 'package:vivapro/pages/contact_picker_page.dart';
import 'package:vivapro/pages/home/widgets/favorites_card.dart';

class FavoritesSection extends ConsumerStatefulWidget {
  const FavoritesSection({super.key});

  @override
  ConsumerState<FavoritesSection> createState() => _FavoritesSectionState();
}

class _FavoritesSectionState extends ConsumerState<FavoritesSection> {
  late final Stream<List<FavoriteContact>> _favoritesStream;

  @override
  void initState() {
    super.initState();
    _favoritesStream = ref.read(favoriteCacheServiceProvider).watchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Favorites',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const FavoritesPage())),
              child: Text(
                'View all',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 210,
          child: StreamBuilder<List<FavoriteContact>>(
            stream: _favoritesStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                );
              }

              final favorites = snapshot.data ?? [];

              if (favorites.isEmpty) {
                return Center(
                  child: InkWell(
                    onTap: () async {
                      // Request contact permission
                      if (await FlutterContacts.requestPermission() && context.mounted) {
                        final contact = await Navigator.of(context).push<Contact?>(
                          MaterialPageRoute(builder: (_) => const ContactPickerPage()),
                        );
                        if (contact != null && context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => AddFavoritePage(contact: contact)),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: 160,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.plusCircleOutline,
                            color: Colors.grey,
                            size: 30,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Add Favorites",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: favorites.length,
                separatorBuilder: (_, _) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  return FavoritesCard(contact: favorites[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
