import 'package:flutter/material.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class InsightsSection extends StatelessWidget {
  const InsightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Insights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C2029) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: GlobalColors.boxShadow(context),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bolt, color: Colors.amber[600], size: 16),
                          const SizedBox(width: 6),
                          const Text(
                            'RECONNECT',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Reconnect with John',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "It's been 12 days since you last spoke.",
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            backgroundColor: Colors.lightBlue.withValues(alpha: .25),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text('Schedule Call', style:  Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    // Image placeholder
                    color: Colors.grey[800],
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1590086782957-93c06ef21604?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
                      ), // Placeholder
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 140,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF131D2A) : Colors.greenAccent.withValues(alpha: .25),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: GlobalColors.boxShadow(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: GlobalColors.containerColor(context),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.people_outline,
                        color: Color(0xFF2D8CFF),
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '85%',
                      style: TextStyle(
                        color: isDark ? Color(0xFF2D8CFF) : Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Relationship Health',
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 140,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: GlobalColors.containerColor(context),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: GlobalColors.boxShadow(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '3',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Calls planned',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}