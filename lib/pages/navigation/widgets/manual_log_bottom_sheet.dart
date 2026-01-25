import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/components/show_flushbar_custom.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:vivapro/pages/contact_picker_page.dart';

class ManualLogBottomSheet extends StatefulWidget {
  final Contact? contact;
  final int? existingActivityId;
  const ManualLogBottomSheet({super.key, this.contact, this.existingActivityId});

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

  Future<void> _pickContact() async {
    final contact = await Navigator.push<Contact>(
      context,
      MaterialPageRoute(
        builder: (context) => const ContactPickerPage(),
      ),
    );
    if (contact != null) {
      setState(() => _selectedContact = contact);
    }
  }

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

    final activity = ActivityLog(
      contactId: _selectedContact!.id,
      contactName: _selectedContact!.displayName,
      phoneNumber: _selectedContact!.phones.isNotEmpty 
          ? _selectedContact!.phones.first.number 
          : null,
      type: response['type'] as ActivityType,
      timestamp: DateTime.now(),
      notes: response['label'] as String,
    )..id = widget.existingActivityId ?? Isar.autoIncrement;

    context.read<ActivityBloc>().add(AddActivity(activity));
    Navigator.of(context).pop();
    
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

      final activity = ActivityLog(
        contactId: _selectedContact!.id,
        contactName: _selectedContact!.displayName,
        phoneNumber: _selectedContact!.phones.isNotEmpty 
            ? _selectedContact!.phones.first.number 
            : null,
        type: _selectedType,
        timestamp: DateTime.now(),
        notes: _notes,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              Text(
                'Log Interaction',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track interactions that happened outside the app',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              
              // Contact Selection
              InkWell(
                onTap: _pickContact,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C3E) : const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedContact != null 
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                        child: Icon(
                          _selectedContact != null ? Icons.person : Icons.person_add,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedContact?.displayName ?? 'Select Contact',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                              ),
                            ),
                            if (_selectedContact != null && _selectedContact!.phones.isNotEmpty)
                              Text(
                                _selectedContact!.phones.first.number,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Quick Responses
              Text(
                'Quick Responses',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickResponses.map((response) {
                  return InkWell(
                    onTap: () => _logQuickResponse(response),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C3E) : const Color(0xFFF2F4F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            response['icon'] as IconData,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            response['label'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              
              // Divider
              Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),
              const SizedBox(height: 24),
              
              // Custom Log Form
              Text(
                'Custom Log',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A1D1E),
                ),
              ),
              const SizedBox(height: 16),
              
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<ActivityType>(
                      initialValue: _selectedType,
                      decoration: InputDecoration(
                        labelText: 'Interaction Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2C2C3E) : const Color(0xFFF2F4F7),
                      ),
                      items: ActivityType.values.map((type) {
                        IconData icon;
                        switch (type) {
                          case ActivityType.call:
                            icon = Icons.phone;
                            break;
                          case ActivityType.message:
                            icon = Icons.message;
                            break;
                          case ActivityType.meeting:
                            icon = Icons.people;
                            break;
                          case ActivityType.other:
                            icon = Icons.more_horiz;
                            break;
                        }
                        
                        return DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Icon(icon, size: 18),
                              const SizedBox(width: 8),
                              Text(type.toString().split('.').last.toUpperCase()),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedType = value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Notes (Optional)',
                        hintText: 'Add details about this interaction...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2C2C3E) : const Color(0xFFF2F4F7),
                      ),
                      maxLines: 3,
                      onSaved: (value) => _notes = value,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _logCustomInteraction,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Log Interaction'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
