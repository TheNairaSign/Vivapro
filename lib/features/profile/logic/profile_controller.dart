import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivapro/features/profile/data/user_profile.dart';
import 'package:vivapro/features/profile/repositories/profile_repository.dart';
import 'package:vivapro/features/backup/data/backup_service.dart';

class ProfileController extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;
  final BackupService _backupService;

  ProfileController(this._repository, this._backupService) : super(const AsyncValue.data(null));

  Future<void> updateProfile({required String name, required String email}) async {
    state = const AsyncValue.loading();
    try {
      final currentProfile = await _repository.getProfile() ?? UserProfile(name: name, email: email);
      currentProfile.name = name;
      currentProfile.email = email;
      await _repository.saveProfile(currentProfile);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> enableBackup() async {
    state = const AsyncValue.loading();
    try {
      await _backupService.enableBackup();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> disableBackup() async {
    state = const AsyncValue.loading();
    try {
      await _backupService.disableBackup();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<void>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  final backupService = ref.watch(backupServiceProvider);
  return ProfileController(repository, backupService);
});
