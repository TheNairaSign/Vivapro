import 'package:flutter/material.dart';

class CallNoteCard extends StatelessWidget {
  final TextEditingController noteController;

  const CallNoteCard({super.key, required this.noteController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
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
          Row(
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Call Note",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: noteController,
            maxLines: 3,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
              hintText: "What's this call about?",
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}