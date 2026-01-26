import 'package:flutter/material.dart';
import 'package:vivapro/features/schedule_call/presentation/widgets/reschedule_modal.dart';

class CallNotificationPage extends StatelessWidget {
  const CallNotificationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'WEEKLY CHECK-IN',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/avatars/flat-top-boy.jpg'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Call John Doe',
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  "It's been 2 weeks since you last spoke.\nTime to catch up?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Call Now',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const RescheduleModal(),
                    );
                  },
                  child: Text(
                    'Remind me later',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
