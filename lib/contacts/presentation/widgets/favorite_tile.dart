import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/contacts/repositories/favorite_repository.dart';
import 'package:vivapro/core/enums/call_frequency.dart';
import 'package:vivapro/core/extensions/capitalization.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class FavoriteTile extends ConsumerWidget {
  final Contact contact;
  final CallFrequency frequency;
  final bool isStarred;

  const FavoriteTile({
    super.key,
    required this.contact,
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
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

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
            radius: 25,
            backgroundColor: Colors.lightBlue.withValues(alpha: 0.1),
            child: Text(
              (contact.displayName.isNotEmpty) ? contact.displayName.characters.first.toUpperCase() : '?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.lightBlue, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.displayName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: freqencyColor?.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    frequency.name.capitalize(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12, color: freqencyColor, fontWeight: FontWeight.bold),
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
            backgroundColor: Colors.lightBlue,
            child: const Icon(Icons.call, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
