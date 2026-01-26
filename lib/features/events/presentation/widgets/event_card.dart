import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/features/events/data/calendar_event.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_bloc.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_event.dart';

class EventCard extends StatelessWidget {
  final CalendarEvent event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('h:mm a').format(DateTime(0, 0, 0, event.timeHour, event.timeMinute));

    return Dismissible(
      key: Key('event_${event.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 0),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(EvaIcons.trash2Outline, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<CalendarEventBloc>().add(CalendarEventDelete(event.id));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: event.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                EvaIcons.calendarOutline,
                color: event.color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(EvaIcons.clockOutline, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        timeStr,
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                      if (event.description.isNotEmpty) ...[
                         const SizedBox(width: 12),
                         Icon(EvaIcons.textOutline, size: 14, color: Colors.grey[500]),
                         const SizedBox(width: 4),
                         Expanded(
                           child: Text(
                             event.description,
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                             style: TextStyle(color: Colors.grey[500], fontSize: 13),
                           ),
                         ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
