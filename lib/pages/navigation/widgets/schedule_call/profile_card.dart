import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:ionicons/ionicons.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = contact.photo != null && contact.photo!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  backgroundImage: hasPhoto ? MemoryImage(contact.photo!) : null,
                  child: !hasPhoto
                      ? Text(
                          (contact.displayName.isNotEmpty) ? contact.displayName.characters.first.toUpperCase() : '?',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        )
                      : null,
                ),
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            contact.displayName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              contact.phones.isNotEmpty ? contact.phones.first.number : "No number",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Ionicons.calendar_outline,
                size: 14,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Text(
                "Scheduling dynamic call...",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
