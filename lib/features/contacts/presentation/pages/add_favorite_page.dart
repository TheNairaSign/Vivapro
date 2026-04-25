import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart';
import 'package:vivapro/features/contacts/data/add_favorites_provider.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorites/frequency_container.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorites/profile_details_section.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorites/profile_uploader_section.dart';
import 'package:vivapro/components/show_flushbar_custom.dart';

class AddFavoritePage extends ConsumerStatefulWidget {
  const AddFavoritePage({super.key, required this.contact});
  final Contact contact;

  @override
  ConsumerState<AddFavoritePage> createState() => _AddFavoritePageState();
}

class _AddFavoritePageState extends ConsumerState<AddFavoritePage> {
  bool isLoading = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contact.displayName ?? '';
    if (widget.contact.phones.isNotEmpty) {
      _phoneController.text = widget.contact.phones.first.number;
    }
  }

  Future<void> submitContact() async {
    if (isLoading) return;

    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      showFlushbarCustom(context, 'Missing Info', 'Please fill in all fields');
      return;
    }

    setState(() => isLoading = true);

    final favoritesProvider = context.read<AddFavoritesProvider>();

    try {
      if (widget.contact.id == null) {
        showFlushbarCustom(context, 'Error', 'Failed to save contact: Contact ID is null');
        return;
      } 
      await ref.read(favoriteCacheServiceProvider).addFavorite(
        FavoriteContact.create(
          id: widget.contact.id!,
          callFrequency: favoritesProvider.callFrequency,
          contactDetails: widget.contact,
          priority: favoritesProvider.callPriority,
          updatedAt: DateTime.now(),
          profilePhotoUrl: favoritesProvider.profilePhotoUrl,
        ),
      );

      if (mounted) {
        Navigator.pop(context);
        showFlushbarCustom(context, 'Success', 'Contact saved successfully');
      }
    } catch (e) {
      if (mounted) {
        showFlushbarCustom(context, 'Error', 'Failed to save contact: $e');
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          'Add Favorite',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDark ? Colors.white : const Color(0xFF101828),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          children: [
            ProfileUploaderSection(),
            const SizedBox(height: 35),
            ProfileDetailsSection(nameController: _nameController, phoneController: _phoneController),
            const SizedBox(height: 25),
            FrequencyContainer(),
            const SizedBox(height: 30),
            _buildSaveButton(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(Color primaryColor) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: primaryColor,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : submitContact,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Save to Favorites',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, size: 18),
                  ),
                ],
              ),
      ),
    );
  }
 
}
