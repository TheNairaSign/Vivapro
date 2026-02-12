import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

Future<void> addEventToCalendar({
  required String title,
  required String description,
  required DateTime start,
  required DateTime end,
  RecurrenceRule? recurrenceRule,
}) async {
  final permissionsGranted = await _deviceCalendarPlugin.requestPermissions();

  if (permissionsGranted.isSuccess != true || permissionsGranted.data != true) return;

  // Get available calendars
  final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
  final calendars = calendarsResult.data;

  if (calendars == null || calendars.isEmpty) return;

  final selectedCalendar = calendars.first;

  final event = Event(
    selectedCalendar.id,
    title: title,
    description: description,
    start: tz.TZDateTime.from(start, tz.local),
    end: tz.TZDateTime.from(end, tz.local),
    recurrenceRule: recurrenceRule,
  );

  await _deviceCalendarPlugin.createOrUpdateEvent(event);
}
