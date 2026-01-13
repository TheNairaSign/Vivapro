import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_bloc.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_event.dart';
import 'package:vivapro/features/schedule_call/presentation/bloc/schedule_call_state.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_call_page.dart';
import 'package:vivapro/features/schedule_call/presentation/pages/schedule_details_page.dart';
import 'package:vivapro/pages/contact_picker_page.dart';

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

  String _formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, y').format(date);
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Planned Calls",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 2,
        actionsPadding: EdgeInsets.only(right: 15),
        actions: [
          GestureDetector(
            onTap: () async {
              final contact = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactPickerPage()),
              );
              if (contact != null && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScheduleCallPage(contact: contact)),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: !isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset('assets/svgs/plus.svg', width: 20, height: 20, colorFilter: ColorFilter.mode(!isDarkMode ? Colors.white : Colors.grey[900]!, BlendMode.srcIn)),
          )
          )
        ],
      ),
      body: BlocConsumer<ScheduleCallBloc, ScheduleCallState>(
        listener: (context, state) {
          if (state is ScheduleCallError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
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
                    Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
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
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final schedule = calls[index];
                return Dismissible(
                  key: Key(schedule.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                     return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Schedule"),
                          content: const Text("Are you sure you want to delete this scheduled call?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    context.read<ScheduleCallBloc>().add(ScheduleCallDelete(scheduleId: schedule.id));
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduleDetailsPage(scheduleCall: schedule),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: GlobalColors.containerColor(context),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundImage: (schedule.contact.photo != null)
                              ? MemoryImage(schedule.contact.photo!)
                              : null,
                          child: (schedule.contact.photo == null)
                              ? Text(
                                  schedule.contact.displayName.isNotEmpty
                                      ? schedule.contact.displayName[0]
                                      : '?',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                        title: Text(
                          schedule.contact.displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDate(schedule.date),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.access_time,
                                    size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTime(schedule.time),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            if (schedule.note.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                schedule.note,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.call, color: Colors.green),
                          onPressed: () {
                            // TODO: Initiate call logic
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          // Default or Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}