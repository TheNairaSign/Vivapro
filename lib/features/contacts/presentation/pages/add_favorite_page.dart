import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:provider/provider.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/contacts/presentation/widgets/favorites/frequency_container.dart';
import 'package:vivapro/widgets/custom_text_field.dart';
import 'package:vivapro/components/show_flushbar.dart';

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
      showFlushbarCustom(context, 'Missing Info', 'Please fill in all fields');
      return;
    }

    setState(() => isLoading = true);

    final favoritesProvider = context.read<AddFavoritesProvider>();

    try {
      await ref.read(favoriteCacheServiceProvider).addFavorite(
        FavoriteContact.create(
          id: widget.contact.id,
          callFrequency: favoritesProvider.callFrequency,
          contactDetails: widget.contact,
          priority: favoritesProvider.callPriority,
          updatedAt: DateTime.now(),
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
            _buildProfileUploader(isDark),
            const SizedBox(height: 48),
            
            // Main Info Card
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('FULL NAME'),
                  const SizedBox(height: 14),
                  CustomTextfield(
                    controller: _nameController,
                    hintText: 'e.g. Grandma Rose',
                  ),
                  const SizedBox(height: 32),
                  _buildLabel('PHONE NUMBER'),
                  const SizedBox(height: 14),
                  CustomTextfield(
                    controller: _phoneController,
                    hintText: '(555) 000-0000',
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        EvaIcons.personAdd,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 28),
            
            // Frequency & Priority
            FrequencyContainer(),
            
            const SizedBox(height: 48),
            
            // Save Button
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
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryColor.withBlue(220).withRed(100), // Vibrant shift
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : submitContact,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
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
                  const Text(
                    'Save to Favorites',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
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

  Widget _buildProfileUploader(bool isDark) {
    return Column(
      children: [
        Stack(
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
                backgroundColor: const Color(0xffFFE5D9), // Softer peach
                child: Icon(
                  Icons.person_rounded,
                  size: 60,
                  color: const Color(0xFF101828).withValues(alpha: 0.7),
                ),
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
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {},
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w900,
        color: Color(0xFF98A2B3),
        letterSpacing: 2.0,
      ),
    );
  }
}
