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
import 'package:vivapro/widgets/view_all.dart';

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

  void addFavorite() async {
    final permission = await FlutterContacts.permissions.request(.readWrite);
    if (permission != PermissionStatus.granted) {
      return;
    }
    if (mounted) {
      final contact = await Navigator.of(context).push<Contact?>(
        MaterialPageRoute(builder: (_) => const ContactPickerPage()),
      );
      if (contact != null && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AddFavoritePage(contact: contact)),
        );
      }
    }
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            ViewAll(
              title: "My Favorites",
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritesPage())),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<FavoriteContact>>(
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
                child: AddFavoriteButton(onTap: addFavorite),
              );
            }
        
            return SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: favorites.length + 1,
                separatorBuilder: (_, _) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  if (index == favorites.length) {
                    return _SubtleAddButton(onTap: addFavorite);
                  }
                  return FavoritesCard(contact: favorites[index]);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SubtleAddButton extends StatelessWidget {
  const _SubtleAddButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  EvaIcons.plus,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AddFavoriteButton extends StatelessWidget {
  const AddFavoriteButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 160,
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
    );
  }
}