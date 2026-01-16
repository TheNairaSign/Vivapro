import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorites/frequency_container.dart';
import 'package:vivapro/features/contacts/repositories/favorite_repository.dart';
import 'package:vivapro/widgets/custom_text_field.dart';

class AddFavoritePage extends ConsumerStatefulWidget {
  const AddFavoritePage({super.key, required this.contact});
  final Contact contact;

  @override
  ConsumerState<AddFavoritePage> createState() => _AddFavoritePageState();
}

class _AddFavoritePageState extends ConsumerState<AddFavoritePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.contact.displayName;
    if (widget.contact.phones.isNotEmpty) {
      _phoneController.text = widget.contact.phones.first.number;
    }
  }

  Future<void> submitContact() async {
    if (isLoading) return;

    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    final favoritesProvider = context.read<AddFavoritesProvider>();

    try {
      await ref.read(favoritesRepository).addFavorite(
        FavoriteContact(
          id: widget.contact.id,
          callFrequency: favoritesProvider.callFrequency,
          contactDetails: widget.contact,
          priority: favoritesProvider.callPriority,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact saved successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save contact: $e')),
        );
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

    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
        title: Text(
          'Add Favorite',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDark ? Colors.white : const Color(0xFF101828),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileUploader(isDark),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20), // Card padding
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('FULL NAME'),
                  const SizedBox(height: 8),
                  CustomTextfield(
                    controller: _nameController,
                    hintText: 'e.g. Grandma Rose',
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('PHONE NUMBER'),
                  const SizedBox(height: 8),
                  CustomTextfield(
                    controller: _phoneController,
                    hintText: '(555) 000-0000',
                    suffixIcon: Icon(
                      Icons.perm_contact_calendar_outlined,
                      color: Colors.blue[400],
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FrequencyContainer(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFF4A8BCA), width: 1),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Save Contact',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.check, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileUploader(bool isDark) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFFFAB896),
                child: Icon(Icons.person, size: 50, color: Color(0xFF101828)),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Color(0xFF5A9BD5),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.lightBlue, width: 1),
            ),
          ),
          onPressed: () {},
          child: Text(
            'Upload Photo',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Color(0xFF98A2B3),
        letterSpacing: 0.5,
      ),
    );
  }
}
