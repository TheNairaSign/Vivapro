import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/models/contact/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/utils/call_modal.dart';
import 'package:vivapro/core/utils/message_modal.dart';
import 'package:vivapro/core/utils/video_modal.dart';

class ContactActionButtons extends ConsumerWidget {
  final Contact contact;

  const ContactActionButtons({super.key, required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: () async {
              final phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : null;
              if (phoneNumber != null && contact.id != null) {
                showCallOptionsModal(
                  context: context,
                  ref: ref,
                  phoneNumber: phoneNumber,
                  contactId: contact.id!,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No phone number available for this contact')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(EvaIcons.phone, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Call ${contact.displayName?.split(' ').first}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryButton(
                context,
                icon: EvaIcons.messageSquareOutline,
                label: 'Message',
                onTap: () {
                  final phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : null;
                  if (phoneNumber != null && contact.id != null) {
                    showMessageOptionsModal(
                      context: context,
                      ref: ref,
                      phoneNumber: phoneNumber,
                      contactId: contact.id!,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No phone number available')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryButton(
                context,
                icon: EvaIcons.videoOutline,
                label: 'Video',
                onTap: () {
                  final phoneNumber = contact.phones.isNotEmpty ? contact.phones.first.number : null;
                  if (phoneNumber != null && contact.id != null) {
                    showVideoOptionsModal(
                      context: context,
                      ref: ref,
                      phoneNumber: phoneNumber,
                      contactId: contact.id!,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No phone number available')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
