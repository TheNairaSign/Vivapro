import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/contacts/presentation/widgets/contact_details/contact_action_buttons.dart';
import 'package:vivapro/contacts/presentation/widgets/contact_details/contact_history_section.dart';
import 'package:vivapro/contacts/presentation/widgets/contact_details/contact_profile_header.dart';
import 'package:vivapro/contacts/presentation/widgets/contact_details/contact_relationship_health.dart';
import 'package:vivapro/contacts/presentation/widgets/contact_details/contact_settings_list.dart';

class ContactDetailsPage extends ConsumerStatefulWidget {
  final Contact contact;
  const ContactDetailsPage(this.contact, {super.key});

  @override
  ConsumerState<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends ConsumerState<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Edit functionality
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          ContactProfileHeader(contact: widget.contact),
          const SizedBox(height: 30),
          ContactActionButtons(contact: widget.contact),
          const SizedBox(height: 30),
          ContactRelationshipHealth(),
          const SizedBox(height: 30),
          ContactSettingsList(),
          const SizedBox(height: 30),
          ContactHistorySection(contact: widget.contact),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
