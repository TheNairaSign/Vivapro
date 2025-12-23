import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class ContactRelationshipHealth extends StatelessWidget {

  const ContactRelationshipHealth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Relationship Health',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: GlobalColors.containerColor(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: GlobalColors.boxShadow(context),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: _buildHealthCard(
                  icon: Ionicons.call_outline,
                  label: 'LAST CALL',
                  value: '2 days ago',
                  subtitle: 'Sunday, 4:20 PM',
                  iconColor: Colors.blue,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildHealthCard(
                  icon: Ionicons.calendar_outline,
                  label: 'AVG FREQ',
                  value: 'Weekly',
                  subtitle: 'Usually weekends',
                  iconColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthCard({
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: iconColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
