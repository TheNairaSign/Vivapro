import 'package:isar/isar.dart';
import 'package:vivapro/features/profile/data/user_profile.dart';
import 'package:vivapro/features/contacts/data/favorite_cache_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileRepository {
  final Isar isar;

  ProfileRepository(this.isar);

  Stream<UserProfile?> watchProfile() {
    return isar.userProfiles.where().watch(fireImmediately: true).map((events) {
      if (events.isEmpty) {
        return UserProfile(name: "Guest User", email: "guest@vivapro.app");
      }
      return events.first;
    });
  }

  Future<UserProfile?> getProfile() async {
    return await isar.userProfiles.where().findFirst();
  }

  Future<void> saveProfile(UserProfile profile) async {
    await isar.writeTxn(() async {
      await isar.userProfiles.clear();
      await isar.userProfiles.put(profile);
    });
  }

  Future<void> clearProfile() async {
    await isar.writeTxn(() async {
      await isar.userProfiles.clear();
    });
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return ProfileRepository(isar);
});

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(profileRepositoryProvider).watchProfile();
});
