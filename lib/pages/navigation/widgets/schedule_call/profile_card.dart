import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/pages/navigation/schedule_call_page.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = contact.photo != null && contact.photo!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: GlobalColors.containerColor(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: GlobalColors.boxShadow(context),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
                backgroundImage: hasPhoto
                    ? MemoryImage(  contact.photo!)
                    : null,
                child: !hasPhoto
                    ? Text(
                        (contact.displayName.isNotEmpty)
                            ? contact.displayName.characters.first
                                  .toUpperCase()
                            : '?',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      )
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            contact.displayName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Contact", // Placeholder as relationships aren't standard in basic contacts
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 12,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Ionicons.time_outline, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "Last called 2 weeks ago", // Mock data
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
