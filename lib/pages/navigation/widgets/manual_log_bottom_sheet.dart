import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/components/show_flushbar_custom.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/pages/navigation/widgets/contact_selection_container.dart';
import 'package:vivapro/pages/navigation/widgets/quick_response_grid.dart';
import 'package:vivapro/pages/navigation/widgets/manual_log_form.dart';
import 'package:vivapro/pages/navigation/widgets/manual_log_header.dart';
import 'package:vivapro/pages/navigation/widgets/manual_log_actions.dart';

class ManualLogBottomSheet extends StatefulWidget {
  final Contact? contact;
  final FavoriteContact? favoriteContact;
  final int? existingActivityId;
  const ManualLogBottomSheet({super.key, this.contact, this.existingActivityId, this.favoriteContact});

  @override
  State<ManualLogBottomSheet> createState() => _ManualLogBottomSheetState();
}

class _ManualLogBottomSheetState extends State<ManualLogBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  ActivityType _selectedType = ActivityType.other;
  String? _notes;
  Contact? _selectedContact;

  @override
  void initState() {
    super.initState();
    _selectedContact = widget.contact;
  }

  // Quick response options
  final List<Map<String, dynamic>> _quickResponses = [
    {'icon': Icons.coffee, 'label': 'Met for coffee', 'type': ActivityType.meeting},
    {'icon': Icons.phone_callback, 'label': 'They called me', 'type': ActivityType.call},
    {'icon': Icons.restaurant, 'label': 'Had lunch together', 'type': ActivityType.meeting},
    {'icon': Icons.message, 'label': 'Sent a message', 'type': ActivityType.message},
    {'icon': Icons.celebration, 'label': 'Celebrated together', 'type': ActivityType.meeting},
    {'icon': Icons.handshake, 'label': 'Business meeting', 'type': ActivityType.meeting},
  ];

  void _logQuickResponse(Map<String, dynamic> response) {
    if (_selectedContact == null) {
      showFlushbarCustom(
        context,
        'Error',
        'Please select a contact first',
        color: Colors.red,
      );
      return;
    }

    final contactName = _selectedContact!.displayName ?? 'John Doe';

    if (_selectedContact!.id == null) {
      showFlushbarCustom(
        context,
        'Error',
        'Please select a contact first',
        color: Colors.red,
      );
      return;
    }

    final activity = ActivityLog(
      favoriteContact: widget.favoriteContact,
      contactName: contactName,
      contactId: _selectedContact!.id!,
      phoneNumber: _selectedContact!.phones.isNotEmpty ? _selectedContact!.phones.first.number : null,
      type: response['type'] as ActivityType,
      timestamp: DateTime.now(),
      notes: response['label'] as String,
    )..id = widget.existingActivityId ?? Isar.autoIncrement;

    context.read<ActivityBloc>().add(AddActivity(activity));
    Navigator.of(context).pop();
    showFlushbarCustom(context, 'Success', 'Log with $contactName successful');
  }

  void _logCustomInteraction() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_selectedContact == null) {
        showFlushbarCustom(
          context,
          'Error',
          'Please select a contact first',
          color: Colors.red,
        );
        return;
      }

      if (_selectedContact!.id == null) {
        showFlushbarCustom(
          context,
          'Error',
          'Please select a contact first',
          color: Colors.red,
        );
        return;
      }

      final activity = ActivityLog(
        favoriteContact: widget.favoriteContact,
        contactName: _selectedContact!.displayName ?? 'John Doe',
        contactId: _selectedContact!.id!,
        phoneNumber: _selectedContact!.phones.isNotEmpty ? _selectedContact!.phones.first.number : null,
        type: _selectedType,
        timestamp: DateTime.now(),
        notes: _notes?.trim(),
      )..id = widget.existingActivityId ?? Isar.autoIncrement;

      context.read<ActivityBloc>().add(AddActivity(activity));
      Navigator.of(context).pop();

      showFlushbarCustom(
        context,
        'Success',
        'Logged interaction with ${_selectedContact!.displayName}',
        color: Colors.green,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ManualLogHeader(),
              ContactSelectionContainer(
                initialContact: _selectedContact,
                onContactSelected: (contact) => setState(() => _selectedContact = contact),
              ),

              QuickResponseGrid(
                responses: _quickResponses,
                onResponseTap: _logQuickResponse,
              ),

              ManualLogForm(
                formKey: _formKey,
                selectedType: _selectedType,
                onTypeChanged: (value) => setState(() => _selectedType = value!),
                onNotesSaved: (value) => _notes = value,
              ),

              ManualLogActions(
                onCancel: () => Navigator.of(context).pop(),
                onLog: _logCustomInteraction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


