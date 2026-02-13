import 'dart:io';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter/material.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/widgets/text_avatar.dart';

class FavoriteAvatar extends StatelessWidget {
  const FavoriteAvatar({
    super.key,
    this.favorite,
    this.contact,
    this.radius = 30,
  });

  final FavoriteContact? favorite;
  final Contact? contact;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. Check for local profile photo override from favorite
    final profilePhotoUrl = favorite?.profilePhotoUrl;
    if (profilePhotoUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        backgroundImage: FileImage(File(profilePhotoUrl)),
      );
    }

    // 2. Check for native contact photo
    final nativePhoto = favorite?.contactDetails.photo ?? contact?.photo;
    if (nativePhoto != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        backgroundImage: MemoryImage(nativePhoto),
      );
    }

    // 3. Fallback to TextAvatar
    final displayName = favorite?.contactDetails.displayName ?? contact?.displayName ?? '?';
    return TextAvatar(
      name: displayName,
      radius: radius,
    );
  }
}
