import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ScheduleCall {
  final String id;
  final Contact contact;
  final DateTime date;
  final TimeOfDay time;
  final String note;

  ScheduleCall({
    this.id = '',
    required this.contact,
    required this.date,
    required this.time,
    required this.note,
  });

  ScheduleCall copyWith({
    String? id,
    Contact? contact,
    DateTime? date,
    TimeOfDay? time,
    String? note,
  }) {
    return ScheduleCall(
      id: id ?? this.id,
      contact: contact ?? this.contact,
      date: date ?? this.date,
      time: time ?? this.time,
      note: note ?? this.note,
    );
  }

  factory ScheduleCall.fromMap(String id, Map<String, dynamic> map) {
    return ScheduleCall(
      id: id,
      contact: Contact.fromJson(map['contact']),
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: map['time']['hour'] as int,
        minute: map['time']['minute'] as int,
      ),
      note: map['note'] as String,
    );
  }

  factory ScheduleCall.fromJson(Map<String, dynamic> json) {
    return ScheduleCall(
      contact: Contact.fromJson(json['contact']),
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: json['time']['hour'] as int,
        minute: json['time']['minute'] as int,
      ),
      note: json['note'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact': contact.toJson(),
      'date': date.toIso8601String(),
      'time': {
        'hour': time.hour,
        'minute': time.minute,
      },
      'note': note,
    };
  }

  @override
  String toString() {
    return 'ScheduleCall(id: $id, contact: $contact, date: $date, time: $time, note: $note)';
  }
}