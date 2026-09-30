import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._localStorage);

  final AppLocalStorage _localStorage;

  @override
  bool get isCompleted => _localStorage.getBool(StorageKeys.onboardingCompleted) ?? false;

  @override
  Future<void> complete() => _localStorage.setBool(StorageKeys.onboardingCompleted, true);
}
