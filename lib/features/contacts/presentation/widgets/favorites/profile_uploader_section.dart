import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:vivapro/features/contacts/data/add_favorites_provider.dart';
import 'package:vivapro/features/contacts/repositories/contact_repository.dart';

class ProfileUploaderSection extends ConsumerWidget {
  const ProfileUploaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoritesProvider = p.Provider.of<AddFavoritesProvider>(context);

    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(ref, favoritesProvider),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: const Color(0xffFFE5D9),
                  backgroundImage: favoritesProvider.profilePhotoUrl != null
                      ? FileImage(File(favoritesProvider.profilePhotoUrl!))
                      : null,
                  child: favoritesProvider.profilePhotoUrl == null
                      ? Icon(
                          Icons.person_rounded,
                          size: 60,
                          color: const Color(0xFF101828).withValues(alpha: 0.7),
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5A9BD5), Color(0xFF3A7BC5)],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_enhance_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _pickImage(ref, favoritesProvider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Update Photo',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(WidgetRef ref, AddFavoritesProvider provider) async {
    final imagePath = await ref.read(contactsRepository).pickFavoriteImage();
    if (imagePath != null) {
      provider.updateProfilePhoto(imagePath);
    }
  }
}