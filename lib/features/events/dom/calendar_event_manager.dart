import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/core/services/notification_service.dart';
import 'package:vivapro/core/utils/add_to_calendar.dart';
import 'package:vivapro/features/events/data/calendar_event.dart';
import 'package:vivapro/features/events/data/event_cache_service.dart';

class CalendarEventManager {
  final EventCacheService local;
  final NotificationService notifications;

  CalendarEventManager({
    required this.local,
    required this.notifications,
  });

  Future<Either<Failure, String>> addEvent(CalendarEvent event) async {
    final result = await local.addEvent(event);
    return result.fold(
      (failure) => left(failure),
      (id) async {
        await notifications.scheduleCalendarEventNotification(event);
        return right(id);
      },
    );
  }

  Stream<List<CalendarEvent>> watchEvents() => local.watchEvents();

  Future<Either<Failure, Unit>> deleteEvent(String id) async {
    await notifications.cancelNotification(id.hashCode);
    return await local.deleteEvent(id);
  }

  Future<void> addToCalendar(CalendarEvent event) async {
    await addEventToCalendar(
      title: event.title,
      description: event.description,
      start: event.date,
      end: event.date.add(const Duration(hours: 1)),
    );
  }
}

final calendarEventManagerProvider = Provider<CalendarEventManager>((ref) {
  return CalendarEventManager(
    local: ref.watch(eventCacheServiceProvider),
    notifications: NotificationService(),
  );
});
