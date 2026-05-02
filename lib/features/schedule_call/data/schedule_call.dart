import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:isar/isar.dart';

part 'schedule_call.g.dart';

@collection
class ScheduleCall {
  Id isarId;

  @Index(unique: true)
  final String id;

  @Index()
  final DateTime date;
  
  final int timeHour;
  final int timeMinute;
  
  final String note;

  /// Internal field for Isar to store the contact details
  final String contactDetailsJson;

  @ignore
  late final Contact contact;

  @ignore
  TimeOfDay get time => TimeOfDay(hour: timeHour, minute: timeMinute);

  @ignore
  DateTime get fullDateTime => DateTime(
        date.year,
        date.month,
        date.day,
        timeHour,
        timeMinute,
      );

  final DateTime updatedAt;

  ScheduleCall({
    this.isarId = Isar.autoIncrement,
    required this.id,
    required this.date,
    required this.timeHour,
    required this.timeMinute,
    required this.note,
    required this.contactDetailsJson,
    required this.updatedAt,
  }) : contact = Contact.fromJson(jsonDecode(contactDetailsJson));

  /// Factory constructor to create a ScheduleCall from a Contact object
  factory ScheduleCall.create({
    Id isarId = Isar.autoIncrement,
    required String id,
    required Contact contact,
    required DateTime date,
    required TimeOfDay time,
    required String note,
    DateTime? updatedAt,
  }) {
    return ScheduleCall(
      isarId: isarId,
      id: id,
      date: date,
      timeHour: time.hour,
      timeMinute: time.minute,
      note: note,
      contactDetailsJson: jsonEncode(contact.toJson()),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  ScheduleCall copyWith({
    Id? isarId,
    String? id,
    Contact? contact,
    DateTime? date,
    TimeOfDay? time,
    String? note,
    DateTime? updatedAt,
  }) {
    return ScheduleCall.create(
      isarId: isarId ?? this.isarId,
      id: id ?? this.id,
      contact: contact ?? this.contact,
      date: date ?? this.date,
      time: time ?? this.time,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ScheduleCall.fromMap(String id, Map<String, dynamic> map) {
    return ScheduleCall.create(
      id: id,
      contact: Contact.fromJson(map['contact']),
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: map['time']['hour'] as int,
        minute: map['time']['minute'] as int,
      ),
      note: map['note'] as String,
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt'] as String) 
          : DateTime.now(),
    );
  }

  factory ScheduleCall.fromJson(Map<String, dynamic> json) {
    return ScheduleCall.create(
      id: json['id'] ?? '',
      contact: Contact.fromJson(json['contact']),
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: json['time']['hour'] as int,
        minute: json['time']['minute'] as int,
      ),
      note: json['note'] as String,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contact': contact.toJson(),
      'date': date.toIso8601String(),
      'time': {
        'hour': timeHour,
        'minute': timeMinute,
      },
      'note': note,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ScheduleCall(isarId: $isarId, id: $id, contact: $contact, date: $date, time: $time, note: $note)';
  }
}