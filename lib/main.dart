import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/core/app.dart';
import 'package:vivapro/core/bootstrap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vivapro/features/activity/data/models/activity_log.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:vivapro/features/contacts/data/favorite_contact.dart';
import 'package:isar/isar.dart';

import 'package:vivapro/features/schedule_call/data/schedule_call.dart';

void main(List<String> args) async {
  await bootstrap();
  final dir = await getApplicationDocumentsDirectory();
  
  final isar = Isar.getInstance() ?? await Isar.open(
    [FavoriteContactSchema, ScheduleCallSchema, ActivityLogSchema],
    directory: dir.path,
  );
  runApp(ProviderScope(
    overrides: [
      isarProvider.overrideWith((ref) => isar),
    ],
    child: const Vivapro()),
  );
}
