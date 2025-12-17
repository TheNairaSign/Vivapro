import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactRepository {
  List<Contact> _contacts = [];
  bool _hasLoaded = false;
  Future<List<Contact>>? _loadingFuture;

  Future<List<Contact>> getContacts({bool forceRefresh = false}) async {
    if (_hasLoaded && !forceRefresh) {
      return _contacts;
    }

    // Return the existing future if a fetch is already in progress
    if (_loadingFuture != null) {
      return _loadingFuture!;
    }

    _loadingFuture = _fetchContacts();
    return _loadingFuture!;
  }

  Future<List<Contact>> _fetchContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        _contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );
        _hasLoaded = true;
      }
      return _contacts;
    } finally {
      _loadingFuture = null;
    }
  }

  Future<List<String>> matchContactIdToName(List<String> ids) async {
    // Ensure contacts are loaded before matching
    if (!_hasLoaded) {
      await getContacts();
    }
    return ids.map((id) {
      try {
        final contact = _contacts.firstWhere((element) => element.id == id);
        return contact.displayName;
      } catch (_) {
        return id;
      }
    }).toList();
  }
}

final contactsRepository = Provider<ContactRepository>((ref) => ContactRepository());