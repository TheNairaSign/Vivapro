import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ContactPickerPage extends StatefulWidget {
  const ContactPickerPage({super.key});

  @override
  State<ContactPickerPage> createState() => _ContactPickerPageState();
}

class _ContactPickerPageState extends State<ContactPickerPage> {
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
         leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select a Contact',
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
          color: Theme.of(context).colorScheme.primary,
          size: 30,
        ),
      );
    }

    if (_contacts!.isEmpty) {
      return const Center(child: Text('No contacts found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 40),
      itemCount: _contacts!.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final contact = _contacts![i];
        final hasPhoto = contact.photo != null && contact.photo!.isNotEmpty;
        
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              backgroundImage: hasPhoto ? MemoryImage(contact.photo!) : null,
              child: !hasPhoto
                  ? Text(
                      (contact.displayName.isNotEmpty)
                          ? contact.displayName.characters.first.toUpperCase()
                          : '?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            title: Text(contact.displayName),
            subtitle: (contact.phones.isNotEmpty)
                ? Text(contact.phones.first.number)
                : null,
            onTap: () {
              Navigator.of(context).pop(contact);
            },
          ),
        );
      },
    );
  }
}
