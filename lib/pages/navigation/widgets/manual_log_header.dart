import 'package:flutter/material.dart';

class ManualLogHeader extends StatelessWidget {
  const ManualLogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Log Interaction',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 21,
            color: isDark ? Colors.white : const Color(0xFF1A1D1E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Track interactions that happened outside the app',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
