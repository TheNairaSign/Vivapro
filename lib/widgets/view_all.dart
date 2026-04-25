import 'package:flutter/material.dart';

class ViewAll extends StatelessWidget {
  final VoidCallback? onTap;

  final String title;
  const ViewAll({super.key, this.onTap, this.title = 'View all'});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              // decoration: TextDecoration.underline,
              // decorationColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.primary, size: 18),
        ],
      ),
    );
  }
}