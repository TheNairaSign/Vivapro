import 'package:flutter/material.dart';


class AddFavoritePage extends StatefulWidget {
  const AddFavoritePage({super.key});

  @override
  State<AddFavoritePage> createState() => _AddFavoritePageState();
}

class _AddFavoritePageState extends State<AddFavoritePage> {
  String _selectedFrequency = 'Weekly';
  String _selectedPriority = 'High';
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
                color: isDark ? const Color(0xFF1A1D1E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: isDark ? null : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                  _buildTextField(
                    controller: _nameController,
                    hint: 'e.g. Grandma Rose',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('PHONE NUMBER'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _phoneController,
                    hint: '(555) 000-0000',
                    isDark: isDark,
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1D1E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: isDark ? null : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                   _buildSectionHeader(
                    icon: Icons.calendar_month,
                    title: 'Call Frequency',
                    isDark: isDark, 
                    iconBgColor: Colors.blue.withOpacity(0.1),
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildSelectionChip('Weekly', _selectedFrequency == 'Weekly')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSelectionChip('Bi-weekly', _selectedFrequency == 'Bi-weekly')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSelectionChip('Monthly', _selectedFrequency == 'Monthly')),
                    ],
                  ),
                  const SizedBox(height: 32),
                   _buildDivider(isDark),
                   const SizedBox(height: 32),
                   _buildSectionHeader(
                    icon: Icons.notifications_active,
                    title: 'Priority Level',
                    isDark: isDark,
                    iconBgColor: const Color(0xFFFFF4E0), // Light orange
                    iconColor: const Color(0xFFD68F00), // Darker orange
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildPriorityCard('High', Icons.star, _selectedPriority == 'High', const Color(0xFFFFD700))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildPriorityCard('Medium', Icons.radio_button_checked, _selectedPriority == 'Medium', Colors.grey)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildPriorityCard('Low', Icons.arrow_downward, _selectedPriority == 'Low', Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
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
                    color: Colors.black.withOpacity(0.1),
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
                      color: Colors.black.withOpacity(0.1),
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
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Color(0xFF98A2B3),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C3032) : const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : const Color(0xFF101828), fontSize: 16),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? Colors.grey[600] : const Color(0xFF98A2B3)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      {required IconData icon, required String title, required bool isDark, required Color iconBgColor, required Color iconColor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF101828),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFrequency = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(20), // Pill shape
          border: isSelected ? Border.all(color: const Color(0xFF5A9BD5), width: 1.5) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF5A9BD5) : const Color(0xFF667085),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityCard(String label, IconData icon, bool isSelected, Color activeColor) {
    return GestureDetector(
      onTap: () => setState(() => _selectedPriority = label),
      child: Container(
        height: 100, // Fixed height for square-ish look
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color:  const Color(0xFFFFD700), width: 1.5) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? activeColor : const Color(0xFF98A2B3), size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF101828) : const Color(0xFF667085),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 1,
      color: isDark ? Colors.grey[800] : const Color(0xFFEAECF0),
    );
  }
}
