import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/local_storage.dart';
import '../storage/storage_keys.dart';

class ThemeService extends Cubit<ThemeMode> {
  ThemeService(this._localStorage) : super(_loadSavedThemeMode(_localStorage));

  final AppLocalStorage _localStorage;

  static ThemeMode _loadSavedThemeMode(AppLocalStorage storage) {
    final name = storage.getString(StorageKeys.themeMode);
    return ThemeMode.values.asNameMap()[name] ?? ThemeMode.system;
  }

  String get themeName {
    if (state == ThemeMode.system) {
      final platformBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return platformBrightness == Brightness.dark ? 'dark' : 'light';
    }
    return state.name;
  }

  void setThemeMode(ThemeMode mode) {
    _localStorage.setString(StorageKeys.themeMode, mode.name);
    emit(mode);
  }
}