import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/pages/navigation/widgets/schedule_call/call_note_card.dart';
import 'package:vivapro/pages/navigation/widgets/schedule_call/date_selection_card.dart';
import 'package:vivapro/pages/navigation/widgets/schedule_call/profile_card.dart';
import 'package:vivapro/pages/navigation/widgets/schedule_call/time_selection_card.dart';

class ScheduleCallPage extends StatefulWidget {
  final Contact contact;

  const ScheduleCallPage({super.key, required this.contact});

  @override
  State<ScheduleCallPage> createState() => _ScheduleCallPageState();
}

class _ScheduleCallPageState extends State<ScheduleCallPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Schedule a Call",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith( fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileCard(contact: widget.contact),
            const SizedBox(height: 20),
            DateSelectionCard(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 20),
            TimeSelectionCard(
              selectedTime: _selectedTime,
              onTimeSelected: (time) {
                setState(() {
                  _selectedTime = time;
                });
              },
            ),
            const SizedBox(height: 20),
            CallNoteCard(noteController: _noteController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement call scheduling logic
                  print('Scheduling call for: ${widget.contact.displayName}');
                  print('Date: $_selectedDate');
                  print('Time: $_selectedTime');
                  print('Note: ${_noteController.text}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: Colors.blue.withValues(alpha: 0.4),
                ),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Schedule Call",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

