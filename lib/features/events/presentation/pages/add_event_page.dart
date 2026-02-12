import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/components/show_flushbar_custom.dart';
import 'package:vivapro/features/events/data/calendar_event.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_bloc.dart';
import 'package:vivapro/features/events/presentation/bloc/calendar_event_event.dart';
import 'package:vivapro/pages/navigation/widgets/schedule_call/date_selection_card.dart';
import 'package:vivapro/pages/navigation/widgets/schedule_call/time_selection_card.dart';
import 'package:uuid/uuid.dart';

class AddEventPage extends ConsumerStatefulWidget {
  final DateTime initialDate;
  const AddEventPage({super.key, required this.initialDate});

  @override
  ConsumerState<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEventPage> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  Color _selectedColor = Colors.blue;
  bool _addToCalendar = false;

  final List<Color> _colors = [
// ... (omitting colors for brevity in replacement, but I will include them in the actual tool call if needed or just replace the whole block)

    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedTime = TimeOfDay.now();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(EvaIcons.arrowIosBack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Event Title", _titleController, Icons.title, "Enter event title"),
            const SizedBox(height: 20),
            _buildTextField("Description", _descriptionController, Icons.description_outlined, "Enter description", maxLines: 3),
            const SizedBox(height: 20),
            const Text("Pick Color", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3) : null,
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            DateSelectionCard(
              selectedDate: _selectedDate,
              onDateSelected: (date) => setState(() => _selectedDate = date),
            ),
            const SizedBox(height: 20),
            TimeSelectionCard(
              selectedTime: _selectedTime,
              onTimeSelected: (time) => setState(() => _selectedTime = time),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: SwitchListTile(
                title: const Text(
                  "Add to device calendar",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  "Sync this event with your local calendar app",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                value: _addToCalendar,
                onChanged: (value) => setState(() => _addToCalendar = value),
                secondary: Icon(
                  Icons.calendar_today_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                activeThumbColor: Theme.of(context).colorScheme.primary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Save Event", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
           enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey, width: .5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: .5,
              ),
            ),
            filled: true,
          ),
        ),
      ],
    );
  }

  void _saveEvent() {
    if (_titleController.text.isEmpty) {
      showFlushbarCustom(context, "Error", "Title cannot be empty", color: Colors.red);
      return;
    }

    final event = CalendarEvent.create(
      id: const Uuid().v4(),
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedDate,
      time: _selectedTime,
      color: _selectedColor,
    );

    context.read<CalendarEventBloc>().add(CalendarEventAdd(
      event,
      addToCalendar: _addToCalendar,
    ));
    Navigator.pop(context);
    showFlushbarCustom(context, "Success", "Event added successfully", color: Colors.green);
  }
}
