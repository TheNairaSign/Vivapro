import 'dart:convert';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:vivapro/features/schedule_call/data/schedule_call.dart';
import 'package:isar/isar.dart';

class GoogleDriveBackupService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveAppdataScope],
  );

  final Isar isar;

  GoogleDriveBackupService(this.isar);

  Future<GoogleSignInAccount?> signIn() async {
    return await _googleSignIn.signIn();
  }

  Future<void> backup() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return;

    final client = await _googleSignIn.authenticatedClient();
    if (client == null) return;

    final driveApi = drive.DriveApi(client);

    // 1. Collect data
    final favorites = await isar.favoriteContacts.where().findAll();
    final schedules = await isar.scheduleCalls.where().findAll();

    final backupData = {
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'favorites': favorites.map((f) => f.toJson()).toList(),
      'schedules': schedules.map((s) => s.toJson()).toList(),
    };

    // 2. Serialize and compress
    final jsonString = jsonEncode(backupData);
    final bytes = utf8.encode(jsonString);
    final compressedBytes = gzip.encode(bytes);

    // 3. Upload to Google Drive (App Data Folder)
    final file = drive.File();
    file.name = 'vivapro_backup.json.gz';
    file.parents = ['appDataFolder'];

    final media = drive.Media(
      Stream.value(compressedBytes),
      compressedBytes.length,
      contentType: 'application/gzip',
    );

    // Check if file already exists
    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = 'vivapro_backup.json.gz'",
    );

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      // Update existing
      await driveApi.files.update(
        file,
        fileList.files!.first.id!,
        uploadMedia: media,
      );
    } else {
      // Create new
      await driveApi.files.create(
        file,
        uploadMedia: media,
      );
    }
  }

  Future<void> restore() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return;

    final client = await _googleSignIn.authenticatedClient();
    if (client == null) return;

    final driveApi = drive.DriveApi(client);

    final fileList = await driveApi.files.list(
      spaces: 'appDataFolder',
      q: "name = 'vivapro_backup.json.gz'",
    );

    if (fileList.files == null || fileList.files!.isEmpty) {
      throw Exception('No backup found');
    }

    final fileId = fileList.files!.first.id!;
    final media = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.metadata,
    ) as drive.Media;

    final List<int> dataBytes = [];
    await media.stream.listen((data) {
      dataBytes.addAll(data);
    }).asFuture();

    final decompressedBytes = gzip.decode(dataBytes);
    final jsonString = utf8.decode(decompressedBytes);
    final backupData = jsonDecode(jsonString);

    // 4. Rehydrate Local DB
    await isar.writeTxn(() async {
      await isar.favoriteContacts.clear();
      await isar.scheduleCalls.clear();

      final List favoritesJson = backupData['favorites'];
      final List schedulesJson = backupData['schedules'];

      await isar.favoriteContacts.putAll(
        favoritesJson.map((f) => FavoriteContact.fromJson(f)).toList(),
      );
      await isar.scheduleCalls.putAll(
        schedulesJson.map((s) => ScheduleCall.fromJson(s)).toList(),
      );
    });
  }
}
