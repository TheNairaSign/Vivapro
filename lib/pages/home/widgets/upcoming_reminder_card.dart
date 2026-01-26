import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_call_page.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_details_page.dart';

class UpcomingReminderCard extends ConsumerWidget {
  final ScheduleCall call;
  final DateTime callDateTime;

  const UpcomingReminderCard({
    super.key, 
    required this.call,
    required this.callDateTime,
  });

  @override 
  Widget build(BuildContext context, WidgetRef ref) {
     final callDateTime = DateTime(
      call.date.year,
      call.date.month,
      call.date.day,
      call.time.hour,
      call.time.minute,
    );
    final now = DateTime.now();
    final isMissed = callDateTime.isBefore(now);
    final isNearby = !isMissed && callDateTime.difference(now).inMinutes <= 5;

    return Dismissible(
      key: Key('home_reminder_${call.id}'),
      direction: (isNearby || isMissed) ? DismissDirection.horizontal : DismissDirection.endToStart,
      background: (isNearby || isMissed)
        ? Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: isNearby ? Colors.green.shade400 : Colors.blue.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(isNearby ? EvaIcons.phoneOutline : EvaIcons.calendarOutline, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  isNearby ? "Call Now" : "Reschedule",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        : const SizedBox.shrink(),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(EvaIcons.trash2Outline, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (isNearby) {
            final phoneNumber = call.contact.phones.isNotEmpty
                ? call.contact.phones.first.number
                : null;
            if (phoneNumber != null) {
              final uri = Uri(scheme: 'tel', path: phoneNumber);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            }
          } else if (isMissed) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScheduleCallPage(
                  contact: call.contact,
                  scheduleCall: call,
                ),
              ),
            );
          }
          return false;
        }
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Schedule"),
            content: const Text("Are you sure you want to delete this scheduled call?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        context.read<ScheduleCallBloc>().add(ScheduleCallDelete(scheduleId: call.id));
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleDetailsPage(scheduleCall: call),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            // border: isNearby 
            //   ? Border.all(color: Colors.orange.withValues(alpha: 0.5), width: 2)
            //   : isMissed 
            //     ? Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1)
            //     : null,
            // boxShadow: [
            //   if (!isMissed) BoxShadow(
            //     color: Colors.black.withValues(alpha: 0.05),
            //     blurRadius: 10,
            //     offset: const Offset(0, 4),
            //   ),
            // ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isMissed 
                    ? Colors.red.withValues(alpha: 0.1)
                    : isNearby 
                      ? Colors.orange.withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  isMissed ? EvaIcons.alertCircleOutline : EvaIcons.calendarOutline,
                  color: isMissed 
                    ? Colors.red 
                    : isNearby 
                      ? Colors.orange 
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            call.contact.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isMissed ? Colors.grey[600] : null,
                              decoration: isMissed ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        if (isMissed)
                          StatusLabel(text: 'MISSED', color: Colors.red)
                        else if (isNearby)
                          StatusLabel(text: 'IN < 5 MINS', color: Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          EvaIcons.clockOutline,
                          size: 14,
                          color: isMissed ? Colors.red[300] : Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatReminderTime(call),
                          style: TextStyle(
                            color: isMissed ? Colors.red[300] : Colors.grey[500],
                            fontSize: 13,
                            fontWeight: isMissed ? FontWeight.bold : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


String formatReminderTime(ScheduleCall call) {
  final now = DateTime.now();
  final callDate = DateTime(call.date.year, call.date.month, call.date.day);
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));

  String dateStr;
  if (callDate == today) {
    dateStr = 'Today';
  } else if (callDate == tomorrow) {
    dateStr = 'Tomorrow';
  } else {
    dateStr = DateFormat('MMM d').format(callDate);
  }

  final time = DateTime(0, 0, 0, call.time.hour, call.time.minute);
  final timeStr = DateFormat('h:mm a').format(time);

  return '$dateStr at $timeStr';
}

class StatusLabel extends StatelessWidget {
  final String text;
  final Color color;

  const StatusLabel({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
