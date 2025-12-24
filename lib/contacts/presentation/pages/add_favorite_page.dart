import 'package:flutter/material.dart';
import 'package:vivapro/contacts/presentation/widgets/favorites/frequency_container.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/widgets/custom_text_field.dart';


class AddFavoritePage extends StatefulWidget {
  const AddFavoritePage({super.key});

  @override
  State<AddFavoritePage> createState() => _AddFavoritePageState();
}

class _AddFavoritePageState extends State<AddFavoritePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          'Add Favorite',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF101828),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileUploader(isDark),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20), // Card padding
              decoration: BoxDecoration(
                color: GlobalColors.containerColor(context),
                borderRadius: BorderRadius.circular(24),
                boxShadow: isDark ? null : [
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
                onPressed: () {
                  // Save logic would go here
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A9BD5), // Matching the image blue
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFF4A8BCA), width: 1), // Slight border for depth
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Save Contact',
                      style: TextStyle(
                        fontSize: 18,
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
            const SizedBox(height: 40),
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
                backgroundColor: Color(0xFFFAB896), // Peach color from image
                child: Icon(Icons.person, size: 50, color: Color(0xFF101828)), // Silhouette placeholder
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
                child: const Icon(Icons.camera_alt, color: Color(0xFF5A9BD5), size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Upload Photo',
          style: TextStyle(
            color: const Color(0xFF5A9BD5),
            fontWeight: FontWeight.w500,
            fontSize: 14,
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