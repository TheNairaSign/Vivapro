import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_filter_chips.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorite_tile.dart';
import 'package:vivapro/features/contacts/repositories/favorite_repository.dart';

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
    _favoritesStream = ref.read(favoritesRepository).watchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const FilterChips(),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<FavoriteContact>>(
              stream: _favoritesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint("Error loading favorites: ${snapshot.error}");
                  return const Center(child: Text('Error loading favorites'));
                }
                final favorites = snapshot.data ?? [];
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: favorites
                      .map(
                        (favorite) => FavoriteTile(
                          contact: favorite.contactDetails,
                          frequency: favorite.callFrequency,
                          isStarred: true,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
