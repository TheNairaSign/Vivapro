import 'package:flutter/material.dart';

class RescheduleModal extends StatelessWidget {
  const RescheduleModal({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reschedule with Sarah',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Snooze reminder for...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildGridItem(
                        context,
                        icon: Icons.timer_outlined,
                        title: 'Later',
                        subtitle: '30 minutes',
                      ),
                      _buildGridItem(
                        context,
                        icon: Icons.hourglass_empty,
                        title: 'In an hour',
                        subtitle: 'Focus time',
                      ),
                      _buildGridItem(
                        context,
                        icon: Icons.wb_sunny_outlined,
                        title: 'Tomorrow',
                        subtitle: '9:00 AM',
                      ),
                      _buildGridItem(
                        context,
                        icon: Icons.calendar_today_outlined,
                        title: 'Custom...',
                        subtitle: 'Pick date & time',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Mark as Done',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red[600], fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridItem(BuildContext context,{
    required IconData icon,
    required String title,
    required String subtitle
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: .min,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 32),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
