import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/widgets/text_avatar.dart';

class FavoriteAvatar extends StatelessWidget {
  const FavoriteAvatar({
    super.key,
    required this.contact,
    this.radius = 30,
  });

  final FavoriteContact contact;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (contact.profilePhotoUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        backgroundImage: FileImage(File(contact.profilePhotoUrl!)),
      );
    }

    final photo = contact.contactDetails.photo;
    if (photo != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        backgroundImage: MemoryImage(photo),
      );
    }

    return TextAvatar(
      name: contact.contactDetails.displayName,
      radius: radius,
    );
  }
}
