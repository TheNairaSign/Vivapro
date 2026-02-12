import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:vivapro/widgets/custom_text_field.dart';

class ProfileDetailsSection extends StatelessWidget {
  const ProfileDetailsSection({super.key, required this.nameController, required this.phoneController});
  final TextEditingController nameController, phoneController;

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('FULL NAME', context),
          const SizedBox(height: 14),
          CustomTextfield(
            controller: nameController,
            hintText: 'e.g. Grandma Rose',
          ),
          const SizedBox(height: 32),
          _buildLabel('PHONE NUMBER', context),
          const SizedBox(height: 14),
          CustomTextfield(
            controller: phoneController,
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
    );
  }

   Widget _buildLabel(String text, BuildContext context) {
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