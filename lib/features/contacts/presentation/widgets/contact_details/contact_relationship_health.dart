import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';

class ContactRelationshipHealth extends StatelessWidget {
  final FavoriteContact favorite;
  const ContactRelationshipHealth({super.key, required this.favorite});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final lastInteraction = favorite.lastInteractionAt;
    final lastInteractionStr = lastInteraction != null 
        ? _formatLastInteraction(lastInteraction) 
        : 'Never';
    final interactionDateStr = lastInteraction != null 
        ? DateFormat('EEEE, h:mm a').format(lastInteraction) 
        : 'No interaction recorded';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Relationship Health',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: _buildHealthCard(
                  icon: EvaIcons.phoneOutline,
                  label: 'LAST CALL',
                  value: lastInteractionStr,
                  subtitle: interactionDateStr,
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
                  icon: EvaIcons.calendarOutline,
                  label: 'TARGET FREQ',
                  value: favorite.callFrequency.name[0].toUpperCase() + favorite.callFrequency.name.substring(1),
                  subtitle: 'Recommended',
                  iconColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatLastInteraction(DateTime lastInteraction) {
    final now = DateTime.now();
    final difference = now.difference(lastInteraction);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
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
            Icon(icon, size: 14, color: iconColor),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
    );
  }
}
