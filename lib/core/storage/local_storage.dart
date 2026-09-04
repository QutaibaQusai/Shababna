import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppLocalStorage {
  Future<void> setBool(String key, bool value);
  bool? getBool(String key);
  Future<void> setString(String key, String value);
  String? getString(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class LocalStorageImpl implements AppLocalStorage {
  const LocalStorageImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<void> remove(String key) => _prefs.remove(key);

  @override
  Future<void> clear() => _prefs.clear();
}