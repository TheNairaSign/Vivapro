import 'package:flutter/material.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class CallNoteCard extends StatelessWidget {
  final TextEditingController noteController;

  const CallNoteCard({super.key, required this.noteController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GlobalColors.containerColor(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: GlobalColors.boxShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Call Note",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: GlobalColors.containerColor(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: .2),
            ),
            child: TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Catch up about the trip...",
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade400,
                    ),
                suffixIcon: Icon(
                  Icons.edit_note,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}