import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contact/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/pages/add_favorite_page.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_filter_chips.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_tile.dart';
import 'package:vivapro/features/contacts/presentation/providers/favorite_filter_provider.dart';
import 'package:vivapro/pages/contact_picker_page.dart';
import 'package:vivapro/widgets/custom_back_button.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  late final Stream<List<FavoriteContact>> _favoritesStream;

  @override
  void initState() {
    super.initState();
    _favoritesStream = ref.read(favoriteCacheServiceProvider).watchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Keep in Touch',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        leading: CustomBackButton(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final contact = await Navigator.of(context).push<Contact?>(
            MaterialPageRoute(builder: (ctx) => const ContactPickerPage()),
          );
    
          if (contact != null && context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => AddFavoritePage(contact: contact)),
            );
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Favorite'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          const FilterChips(),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<FavoriteContact>>(
              stream: _favoritesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded, size: 48, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        const Text('Error loading favorites'),
                      ],
                    ),
                  );
                }
                final selectedFilter = ref.watch(favoriteFilterProvider);
                final favorites = (snapshot.data ?? []).where((f) {
                  if (selectedFilter == 'All') return true;
                  return f.callFrequency.name.toLowerCase() == selectedFilter.toLowerCase();
                }).toList();
                
                if (favorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_border_rounded, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          selectedFilter == 'All' 
                              ? 'No favorites yet' 
                              : 'No $selectedFilter favorites',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[400],
                              ),
                        ),
                      ],
                    ),
                  );
                }
    
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: favorites.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final favorite = favorites[index];
                    return FavoriteTile(
                      favoriteContact: favorite,
                      frequency: favorite.callFrequency,
                      isStarred: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
