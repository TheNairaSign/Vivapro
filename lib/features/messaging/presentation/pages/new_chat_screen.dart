import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:vivapro/features/contacts/repositories/contact_repository.dart';
import 'package:vivapro/core/theme/global_colors.dart';
import 'package:vivapro/features/messaging/data/chat.dart';
import 'package:vivapro/features/messaging/repositories/chat_repository.dart';
import 'package:vivapro/features/messaging/presentation/pages/messages_screen.dart';

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
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );
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
        title: Text("New Chat", style: Theme.of(context).textTheme.titleLarge),
        actions: [
          if (_selectedContactIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.greenAccent),
              onPressed: _createChat,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                hintText: "Search contacts",
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                filled: true,
                fillColor: GlobalColors.containerColor(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: GlobalColors.yellow),
                ),
              ),
            ),
            if (_selectedContactIds.isNotEmpty) ...[
              const SizedBox(height: 16),
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
                      backgroundColor: Colors.lightBlue.withValues(alpha: 0.2),
                      label: Text(
                        contact.displayName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      deleteIcon: Icon(Icons.close, size: 18),
                      onDeleted: () => _toggleSelection(id),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildContactList()),
            ],
          ],
        ),
      ),
      floatingActionButton: _selectedContactIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _createChat,
              backgroundColor: Colors.lightBlue,
              label: Text(
                _selectedContactIds.length > 1 ? "Create Group" : "Start Chat",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              icon: Icon(Icons.chat_bubble_outline),
            )
          : null,
    );
  }

  Widget _buildContactList() {
    if (_permissionDenied) {
      return Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: GlobalColors.yellow),
          onPressed: _fetchContacts,
          child: Text(
            'Grant Permission',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    if (_contacts == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_filteredContacts.isEmpty) {
      return const Center(
        child: Text("No contacts found", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.separated(
      itemCount: _filteredContacts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        final isSelected = _selectedContactIds.contains(contact.id);
        return Container(
          decoration: BoxDecoration(
            color: GlobalColors.containerColor(context),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isSelected
                  ? Colors.lightBlue
                  : Colors.lightBlue.withValues(alpha: .1),
              radius: 24,
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      (contact.displayName.isNotEmpty)
                          ? contact.displayName[0].toUpperCase()
                          : '?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            title: Text(
              contact.displayName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isSelected
                    ? Colors.lightBlue
                    : GlobalColors.textThemeColor(context),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: contact.phones.isNotEmpty
                ? Text(
                    contact.phones.first.number,
                    style: TextStyle(color: Colors.grey.shade500),
                  )
                : null,
            onTap: () => _toggleSelection(contact.id),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: Colors.lightBlue)
                : null,
          ),
        );
      },
    );
  }
}
