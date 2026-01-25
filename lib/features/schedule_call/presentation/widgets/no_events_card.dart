import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class NoEventsCard extends StatelessWidget {
  const NoEventsCard({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(EvaIcons.calendarOutline, size: 56, color: Colors.grey[300]),
        ),
        const SizedBox(height: 24),
        Text(
          "Rest Day",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "No calls scheduled for this day",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(EvaIcons.plus, size: 18),
          label: const Text("Plan a Call"),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            side: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }
}