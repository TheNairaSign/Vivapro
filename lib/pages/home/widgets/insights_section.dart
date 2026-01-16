import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/scheduled_calls_page.dart';

class InsightsSection extends StatelessWidget {
  const InsightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insights',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
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
                          Text(
                            'RECONNECT',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Reconnect with John',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "It's been 12 days since you last spoke.",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            backgroundColor: Theme.of(context,).colorScheme.primary.withValues(alpha: .15),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          child: Text(
                            'Schedule Call',
                            style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                          ),
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
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: .25),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Icon(
                        EvaIcons.peopleOutline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '85%',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Relationship Health',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CallsPlannedContainer(),
            ),
          ],
        ),
      ],
    );
  }
}



class CallsPlannedContainer extends StatefulWidget {
  const CallsPlannedContainer({super.key});

  @override
  State<CallsPlannedContainer> createState() => _CallsPlannedContainerState();
}

class _CallsPlannedContainerState extends State<CallsPlannedContainer> {
  int _plannedCalls = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScheduledCallsPage(),
          ),
        );
      },
      child: BlocListener<ScheduleCallBloc, ScheduleCallState>(
        listener: (context, state) {
          if (state is ScheduleCallLoaded) {
            setState(() {
              _plannedCalls = state.scheduleCalls.length;
            });
          }
        },
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
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
              Text(
                '$_plannedCalls',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text('Calls planned', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

