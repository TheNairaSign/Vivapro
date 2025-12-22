import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/contacts/repositories/favorite_repository.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class FavoriteTile extends ConsumerWidget {
  final Contact contact;
  final String frequency;
  final bool isStarred;

  const FavoriteTile({
    super.key,
    required this.contact,
    required this.frequency,
    this.isStarred = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GlobalColors.containerColor(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey[200],
            child: Text(contact.displayName[0]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.displayName, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: callFrequencyColor(CallFrequency.values.firstWhere((e) => e.name == frequency)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    frequency,
                    style: TextStyle(fontSize: 12, color: theme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ref.read(favoritesRepository).toggleFavorite(isStarred, contact);
            },
            icon: Icon(
              isStarred ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF4A90E2),
            child: const Icon(Icons.call, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
