import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/contacts/repositories/contact_repository.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/messaging/data/chat.dart';
import 'package:vivapro/messaging/repositories/chat_repository.dart';
import 'package:vivapro/messaging/presentation/pages/messages_screen.dart';

import 'dart:developer' as dev;

class NewChatScreen extends ConsumerStatefulWidget {
  const NewChatScreen({super.key});

  @override
  ConsumerState<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends ConsumerState<NewChatScreen> {
  List<Contact>? _contacts;
  List<Contact> _filteredContacts = [];
  final Set<String> _selectedContactIds = {};
  bool _permissionDenied = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(_onSearchChanged);
    ref.read(contactsRepository).getContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_contacts == null) return;
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts!.where((c) {
        return c.displayName.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      if (mounted) setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: false);
      if (mounted) {
        setState(() {
          _contacts = contacts;
          _filteredContacts = contacts;
          _permissionDenied = false;
        });
      }
    }
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedContactIds.contains(id)) {
        _selectedContactIds.remove(id);
      } else {
        _selectedContactIds.add(id);
      }
    });
  }

  Future<List<String>> _contactNames(List<String> ids) async {
    final contactsRepo = ref.read(contactsRepository);
    return await contactsRepo.matchContactIdToName(ids);
  }

  Future<void> _createChat() async {
    if (_selectedContactIds.isEmpty) return;

    try {
      final chatRepo = ref.read(chatRepositoryProvider);
      final participantIds = _selectedContactIds.toList();
      final participants = await _contactNames(participantIds);
      final chatId = await chatRepo.createChat(participants);

      dev.log("Participants: $participants", name: "NewChatScreen");
      
      final newChat = Chat(
        id: chatId,
        participants: participants,
        updatedAt: DateTime.now(),
      );

      dev.log("New chat: $newChat", name: "NewChatScreen");

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MessagesScreen(chat: newChat)),
        );
      }
    } catch (e) {
      dev.log("Error creating chat: $e", name: "NewChatScreen");
      // Handle error (e.g. show snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Chat"),
        actions: [
          if (_selectedContactIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: _createChat,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: GlobalColors.darkPurple),
                hintText: "Search contacts",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (_selectedContactIds.isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _selectedContactIds.length,
                separatorBuilder: (ctx, index) => const SizedBox(width: 8),
                itemBuilder: (ctx, index) {
                  final id = _selectedContactIds.elementAt(index);
                  // Find contact object for display (inefficient but works for list size)
                  final contact = _contacts!.firstWhere((c) => c.id == id);
                  return Chip(
                    label: Text(contact.displayName),
                    onDeleted: () => _toggleSelection(id),
                  );
                },
              ),
            ),
          Expanded(child: _buildContactList()),
        ],
      ),
      floatingActionButton: _selectedContactIds.isNotEmpty 
        ? FloatingActionButton.extended(
            onPressed: _createChat,
            label: Text(_selectedContactIds.length > 1 ? "Create Group" : "Start Chat"),
            icon: Icon(Icons.chat_bubble_outline, color: GlobalColors.darkPurple),
          )
        : null,
    );
  }

  Widget _buildContactList() {
    if (_permissionDenied) {
      return Center(
        child: ElevatedButton(
          onPressed: _fetchContacts,
          child: const Text('Grant Permission'),
        ),
      );
    }

    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredContacts.isEmpty) {
      return const Center(child: Text("No contacts found"));
    }

    return ListView.builder(
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        final isSelected = _selectedContactIds.contains(contact.id);
        return ListTile(
          leading: CircleAvatar(
             backgroundColor: isSelected ? GlobalColors.darkPurple : Colors.grey.shade200,
             child: isSelected 
               ? const Icon(Icons.check, color: Colors.white, size: 16)
               : Text(
                   (contact.displayName.isNotEmpty) ? contact.displayName[0].toUpperCase() : '?',
                   style: TextStyle(color: GlobalColors.darkPurple, fontWeight: FontWeight.bold),
                 ),
          ),
          title: Text(contact.displayName),
          subtitle: contact.phones.isNotEmpty ? Text(contact.phones.first.number) : null,
          onTap: () => _toggleSelection(contact.id),
          trailing: isSelected ? Icon(Icons.check_circle, color: GlobalColors.darkPurple) : null,
        );
      },
    );
  }
}
