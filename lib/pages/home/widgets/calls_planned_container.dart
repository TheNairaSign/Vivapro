
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/scheduled_calls_page.dart';

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
          MaterialPageRoute(builder: (context) => const ScheduledCallsPage()),
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
          height: 130,
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Calls planned',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
