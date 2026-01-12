import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/core/theme/global_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF2C2C29)
        : GlobalColors.goldBackground;
    final borderColor = isDark
        ? const Color(0xFF3E3E3A)
        : GlobalColors.goldBorder;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final bodyColor = isDark ? Colors.grey[400] : Colors.black54;

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
              const Icon(
                Icons.lightbulb,
                color: Color(0xFFE67E22),
                size: 18,
              ), // Amber/Orange icon
              const SizedBox(width: 8),
              Text(
                'INSIGHT',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFE67E22),
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
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getFriendlyMessage(insight.daysSinceLastCall),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: bodyColor, height: 1.4),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              final Uri url = Uri(scheme: 'tel', path: insight.phoneNumber);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            icon: const Icon(Icons.call, color: Color(0xFFE67E22), size: 18),
            label: Text(
              'Call ${insight.contactName}',
              style: const TextStyle(
                color: Color(0xFFE67E22),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
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
