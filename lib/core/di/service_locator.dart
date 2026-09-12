import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logging/app_logger.dart';
import '../services/locale_service.dart';
import '../services/theme_service.dart';
import '../storage/local_storage.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<AppLogger>(() => AppLoggerImpl());

  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<AppLocalStorage>(() => LocalStorageImpl(sl()));

  sl.registerLazySingleton<LocaleService>(() => LocaleService(sl()));
  sl.registerLazySingleton<ThemeService>(() => ThemeService(sl()));
}