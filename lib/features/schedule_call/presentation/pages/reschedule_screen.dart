import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class RescheduleScreen extends StatelessWidget {
  const RescheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = GlobalColors.containerColor(context) ?? Colors.white;
    final cardColor = GlobalColors.containerThemeColor(context) ?? Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // Profile Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            'https://randomuser.me/api/portraits/women/44.jpg',
                          ), // Placeholder
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4ADE80), // Online Green
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: backgroundColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reschedule with Sarah',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontSize: 20,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Snooze reminder for...',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: subTextColor,
                                  fontSize: 14,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Grid Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _RescheduleOptionCard(
                        icon: Ionicons.time,
                        iconColor: const Color(0xFFEAB308), // Yellow
                        title: 'Later',
                        subtitle: '30 minutes',
                        cardColor: cardColor,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _RescheduleOptionCard(
                        icon: Ionicons.hourglass_outline,
                        iconColor: const Color(0xFF3B82F6), // Blue
                        title: 'In an hour',
                        subtitle: 'Focus time',
                        cardColor: cardColor,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _RescheduleOptionCard(
                        icon: Ionicons.sunny,
                        iconColor: const Color(0xFFF59E0B), // Ambver
                        title: 'Tomorrow',
                        subtitle: '9:00 AM',
                        cardColor: cardColor,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _RescheduleOptionCard(
                        icon: Ionicons.calendar,
                        iconColor: const Color(0xFF10B981), // Green
                        title: 'Custom...',
                        subtitle: 'Pick date & time',
                        cardColor: cardColor,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Mark as Done Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark 
                          ? const Color(0xFF059669) // Emerald 600 for dark mode
                          : const Color(0xFFECFDF5), // Light Green bg for light mode
                      foregroundColor: isDark
                          ? Colors.white
                          : const Color(0xFF047857), // Dark Green text
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Ionicons.checkmark_circle, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Mark as Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _RescheduleOptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color cardColor;
  final bool isDark;

  const _RescheduleOptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.cardColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? cardColor : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? null : Border.all(color: Colors.grey[100]!),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}