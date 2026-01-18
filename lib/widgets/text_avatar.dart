import 'package:flutter/material.dart';

class TextAvatar extends StatelessWidget {
  const TextAvatar({super.key, required this.name, this.radius = 26});

  final String name;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CircleAvatar(
      radius: radius,
      backgroundColor: isDark
          ? const Color(0xFF3E3E4A)
          : const Color(0xFFE0E0E0),
      backgroundImage: null,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.grey[300] : Colors.grey[700],
        ),
      ),
    );
  }
}