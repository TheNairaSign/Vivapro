import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_call_page.dart';
import 'package:vivapro/pages/contact_picker_page.dart';
import 'package:vivapro/pages/home/widgets/upcoming_reminder_card.dart';
import 'package:vivapro/widgets/custom_back_button.dart';
import 'package:vivapro/components/show_flushbar_custom.dart';

class ScheduledCallsPage extends StatefulWidget {
  const ScheduledCallsPage({super.key});

  @override
  State<ScheduledCallsPage> createState() => _ScheduledCallsPageState();
}

class _ScheduledCallsPageState extends State<ScheduledCallsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduleCallBloc>().add(ScheduleCallFetch());
  }

  void _addSchedule() async {
    final contact = await Navigator.of(context).push<Contact?>(MaterialPageRoute(builder: (ctx) => ContactPickerPage()));

    if (contact != null && mounted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ScheduleCallPage(contact: contact,)));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: _addSchedule,
        child: const Icon(EvaIcons.plus, color: Colors.white),
      ),
      appBar: AppBar(
        title: Text(
          "Planned Calls",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 2,
        actionsPadding: const EdgeInsets.only(right: 15),
        leading: CustomBackButton(),
      ),
      body: BlocConsumer<ScheduleCallBloc, ScheduleCallState>(
        listener: (context, state) {
          if (state is ScheduleCallError) {
            showFlushbarCustom(context, 'Error', state.message, color: Colors.red);
          }
        },
        builder: (context, state) {
          if (state is ScheduleCallLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ScheduleCallLoaded) {
            final calls = state.scheduleCalls;

            if (calls.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(EvaIcons.calendarOutline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "No scheduled calls",
                      style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: calls.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) => UpcomingReminderCard(call: calls[index], callDateTime: calls[index].date),
            );
          }
          // Default or Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}