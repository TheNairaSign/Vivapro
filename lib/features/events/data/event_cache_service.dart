import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:vivapro/core/failures/failure.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/events/data/calendar_event.dart';

class EventCacheService {
  final Isar isar;

  EventCacheService(this.isar);

  Future<Either<Failure, String>> addEvent(CalendarEvent event) async {
    try {
      await isar.writeTxn(() async {
        final existing = await isar.calendarEvents.filter().idEqualTo(event.id).findFirst();
        if (existing != null) {
          event.isarId = existing.isarId;
        }
        await isar.calendarEvents.put(event);
      });
      return right(event.id);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CalendarEvent>> watchEvents() {
    return isar.calendarEvents.where().watch(fireImmediately: true);
  }

  Future<Either<Failure, Unit>> deleteEvent(String id) async {
    try {
      await isar.writeTxn(() async {
        await isar.calendarEvents.filter().idEqualTo(id).deleteAll();
      });
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<List<CalendarEvent>> getEventsForDay(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    return await isar.calendarEvents
      .filter()
      .dateBetween(startOfDay, endOfDay)
      .findAll();
  }
}

final eventCacheServiceProvider = Provider<EventCacheService>((ref) {
  final isar = ref.watch(isarProvider);
  return EventCacheService(isar);
});
