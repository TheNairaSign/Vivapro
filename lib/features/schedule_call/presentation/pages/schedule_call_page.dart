import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:vivapro/features/schedule_call/dom/schedule_call_manager.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_details_page.dart';
import 'package:vivapro/pages/navigation/widgets/schedule_call/call_note_card.dart';
import 'package:vivapro/pages/navigation/widgets/schedule_call/date_selection_card.dart';
import 'package:vivapro/pages/navigation/widgets/schedule_call/profile_card.dart';
import 'package:vivapro/pages/navigation/widgets/schedule_call/time_selection_card.dart';
import 'package:vivapro/components/show_flushbar.dart';

class ScheduleCallPage extends ConsumerStatefulWidget {
  final Contact contact;
  final ScheduleCall? scheduleCall;

  const ScheduleCallPage({super.key, required this.contact, this.scheduleCall});

  @override
  ConsumerState<ScheduleCallPage> createState() => _ScheduleCallPageState();
}

class _ScheduleCallPageState extends ConsumerState<ScheduleCallPage> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.scheduleCall?.date ?? DateTime.now();
    _selectedTime = widget.scheduleCall?.time ?? TimeOfDay.now();
    _noteController = TextEditingController(text: widget.scheduleCall?.note ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleCallBloc(
        manager: ref.read(scheduleCallManagerProvider),
      ),
      child: BlocListener<ScheduleCallBloc, ScheduleCallState>(
        listener: (context, state) {
          if (state is ScheduleCallError) {
            showFlushbar(context, 'Error', state.message, color: Colors.red);
            debugPrint("Error adding schedule: ${state.message}");
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(EvaIcons.arrowIosBack),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.scheduleCall == null ? "Schedule a Call" : "Update Call",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: Builder(
            builder: (context) {
              return SingleChildScrollView(
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
                          final scheduleCall = ScheduleCall.create(
                            id: widget.scheduleCall?.id ?? '',
                            contact: widget.contact,
                            date: _selectedDate,
                            time: _selectedTime,
                            note: _noteController.text,
                          );
                          
                          if (widget.scheduleCall == null) {
                            context.read<ScheduleCallBloc>().add(ScheduleCallAdd(scheduleCall: scheduleCall));
                          } else {
                            context.read<ScheduleCallBloc>().add(ScheduleCallReschedule(scheduleCall: scheduleCall));
                          }
                          
                          final navigator = Navigator.of(context);
                          navigator.pop();
                          showFlushbar(
                            context,
                            'Schedule',
                            widget.scheduleCall == null ? "Call Scheduled" : "Call Updated",
                            mainButton: TextButton(
                              onPressed: () => navigator.push(MaterialPageRoute(builder: (ctx) => ScheduleDetailsPage(scheduleCall: scheduleCall))),
                              child: const Text('View', style: TextStyle(color: Colors.amber)),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              EvaIcons.calendar,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.scheduleCall == null ? "Schedule Call" : "Update Call",
                              style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
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
              );
            }
          ),
        ),
      ),
    );
  }
}



