import 'dart:io';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
      final permission = await FlutterContacts.permissions.request(.readWrite);
      if (permission == PermissionStatus.granted) {
        _contacts = await FlutterContacts.getAll();
        _hasLoaded = true;
      }
      return _contacts;
    } finally {
      _loadingFuture = null;
    }
  }

  // Future<List<String>> matchContactIdToName(List<String> ids) async {
  //   // Ensure contacts are loaded before matching
  //   if (!_hasLoaded) await getContacts();
    
  //   return ids.map((id) {
  //     try {
  //       final contact = _contacts.firstWhere((element) => element.id == id);
  //       return contact.displayName;
  //     } catch (_) {
  //       return id;
  //     }
  //   }).toList();
  // }

  Future<String?> pickFavoriteImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );

    if (image != null) {
      return await _saveImageLocally(image.path);
    }
    return null;
  }

  Future<String> _saveImageLocally(String tempPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final profilePicsDir = Directory(p.join(directory.path, 'profile_pics'));
    
    if (!(await profilePicsDir.exists())) {
      await profilePicsDir.create(recursive: true);
    }

    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${p.extension(tempPath)}';
    final savedFile = await File(tempPath).copy(p.join(profilePicsDir.path, fileName));
    
    return savedFile.path;
  }
  
}

final contactsRepository = Provider<ContactRepository>((ref) => ContactRepository());
