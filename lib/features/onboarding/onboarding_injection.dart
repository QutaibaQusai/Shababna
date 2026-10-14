import 'package:get_it/get_it.dart';

import '../../core/storage/local_storage.dart';
import 'data/repositories/onboarding_repository_impl.dart';
import 'domain/repositories/onboarding_repository.dart';
import 'presentation/cubit/onboarding_cubit.dart';

void registerOnboardingFeature(GetIt sl) {
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl<AppLocalStorage>()),
  );

  sl.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(sl<OnboardingRepository>()),
  );
}
