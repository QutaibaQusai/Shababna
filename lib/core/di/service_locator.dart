import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/locale_service.dart';
import '../storage/local_storage.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<AppLocalStorage>(() => LocalStorageImpl(sl()));

  sl.registerLazySingleton<LocaleService>(() => LocaleService(sl()));
}