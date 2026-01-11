import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vivapro/features/contacts/presentation/pages/contact_details_page.dart';
import 'package:vivapro/core/theme/global_colors.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      if (mounted) setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      if (mounted) {
        setState(() {
          _contacts = contacts;
          _permissionDenied = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Permission denied'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchContacts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_contacts == null) {
      return Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.lightBlue,
          size: 30,
        ),
      );
    }

    if (_contacts!.isEmpty) {
      return const Center(child: Text('No contacts found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 120),
      itemCount: _contacts!.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final contact = _contacts![i];
        return Container(
          decoration: BoxDecoration(
            color: GlobalColors.containerColor(context),
            borderRadius: BorderRadius.circular(12),
            boxShadow: GlobalColors.boxShadow(context),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue.withValues(alpha: 0.1),
              child: Text(
                (contact.displayName.isNotEmpty)
                    ? contact.displayName.characters.first.toUpperCase()
                    : '?',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(contact.displayName),
            subtitle: (contact.phones.isNotEmpty)
                ? Text(contact.phones.first.number)
                : null,
            onTap: () async {
              final fullContact = await FlutterContacts.getContact(contact.id);
              if (context.mounted && fullContact != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ContactDetailsPage(fullContact),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
