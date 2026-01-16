import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/features/call_log/data/models/insight_model.dart';

class InsightCard extends StatelessWidget {
  final InsightModel insight;
  const InsightCard({super.key, required this.insight});

  String _getFriendlyMessage(int days) {
    if (days > 90) {
      final months = (days / 30).floor();
      return "It's been about $months months. A quick check-in goes a long way.";
    }
    if (days > 30) {
      return "It's been over a month. Time to reconnect!";
    }
    if (days > 14) {
      return "It's been a couple of weeks. How are they doing?";
    }
    return "It's been ${insight.daysSinceLastCall} days. A quick 'hello' can make a difference.";
  }

  @override
  Widget build(BuildContext context) {

    final backgroundColor =  Theme.of(context).colorScheme.surface;
    final borderColor = Colors.transparent;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                EvaIcons.bulb,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ), // Amber/Orange icon
              const SizedBox(width: 8),
              Text(
                'INSIGHT',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Reconnect with ${insight.contactName}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getFriendlyMessage(insight.daysSinceLastCall),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              final Uri url = Uri(scheme: 'tel', path: insight.phoneNumber);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            icon: Icon(EvaIcons.phoneOutline, color: Theme.of(context).colorScheme.primary, size: 18),
            label: Text(
              'Call ${insight.contactName}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: .1),
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
