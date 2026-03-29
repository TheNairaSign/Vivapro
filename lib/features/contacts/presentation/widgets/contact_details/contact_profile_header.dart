import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contact/contact.dart';
import 'package:vivapro/widgets/text_avatar.dart';

class ContactProfileHeader extends StatelessWidget {
  final Contact contact;

  const ContactProfileHeader({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {  
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
              ),
              child: contact.photo != null ? CircleAvatar(
                radius: 60,
                backgroundImage: MemoryImage(contact.photo!.thumbnail!),
              ) : TextAvatar(name: contact.displayName ?? 'John Doe', radius: 60, textSize: 40),
            ),
            Positioned(
              bottom: 0,
              right: 12,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          contact.displayName ?? 'John Doe',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'CLOSE FRIEND',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (contact.phones.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_android,
                      size: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Mobile',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
