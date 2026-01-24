import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class TopCallerInfo extends StatelessWidget {
  final String title;
  final MapEntry<String, int>? caller;
  final bool isOverall;

  const TopCallerInfo({
    super.key,
    required this.title,
    required this.caller,
    this.isOverall = false,
  });

  @override
  Widget build(BuildContext context) {
    if (caller == null) return const SizedBox.shrink();

    // Define content colors based on card type
    final textColor = isOverall
        ? const Color(0xFF3E2723)
        : Theme.of(context).textTheme.titleLarge?.color;
    final subTextColor = isOverall
        ? const Color(0xFF3E2723).withAlpha(178)
        : Colors.grey[600];
    final iconColor = isOverall ? const Color(0xFF3E2723) : Colors.blue;
    final iconBgColor = isOverall
        ? const Color(0xFF3E2723).withAlpha(25)
        : Colors.blue.withAlpha(25);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOverall ? null : Theme.of(context).colorScheme.surface,
        gradient: isOverall
          ? const LinearGradient(
              colors: [Color(0xFFFFC107), Color(0xFFFF9800)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isOverall
                ? const Color(0xFFFF9800).withAlpha(76)
                : Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(EvaIcons.person, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: subTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isOverall) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3E2723).withAlpha(25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'ALL TIME',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  caller!.key,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${caller!.value} calls',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isOverall
                        ? const Color(0xFF3E2723).withAlpha(204)
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          if (isOverall)
            const Icon(EvaIcons.award, color: Color(0xFF3E2723), size: 32),
        ],
      ),
    );
  }
}