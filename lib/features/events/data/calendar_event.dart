import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'calendar_event.g.dart';

@collection
class CalendarEvent {
  Id isarId;

  @Index(unique: true)
  final String id;

  @Index()
  final DateTime date;
  
  final int timeHour;
  final int timeMinute;
  
  final String title;
  final String description;
  final int colorValue;

  final DateTime updatedAt;

  CalendarEvent({
    this.isarId = Isar.autoIncrement,
    required this.id,
    required this.date,
    required this.timeHour,
    required this.timeMinute,
    required this.title,
    required this.description,
    required this.colorValue,
    required this.updatedAt,
  });

  @ignore
  TimeOfDay get time => TimeOfDay(hour: timeHour, minute: timeMinute);

  @ignore
  Color get color => Color(colorValue);

  factory CalendarEvent.create({
    Id isarId = Isar.autoIncrement,
    required String id,
    required String title,
    required String description,
    required DateTime date,
    required TimeOfDay time,
    required Color color,
    DateTime? updatedAt,
  }) {
    return CalendarEvent(
      isarId: isarId,
      id: id,
      date: date,
      timeHour: time.hour,
      timeMinute: time.minute,
      title: title,
      description: description,
      colorValue: color.toARGB32(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  CalendarEvent copyWith({
    Id? isarId,
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    Color? color,
    DateTime? updatedAt,
  }) {
    return CalendarEvent.create(
      isarId: isarId ?? this.isarId,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      color: color ?? this.color,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': {
        'hour': timeHour,
        'minute': timeMinute,
      },
      'colorValue': colorValue,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent.create(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: json['time']['hour'] as int,
        minute: json['time']['minute'] as int,
      ),
      color: Color(json['colorValue']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }
}
