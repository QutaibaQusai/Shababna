import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/local_storage.dart';
import '../storage/storage_keys.dart';

class LocaleService extends Cubit<Locale?> {
  LocaleService(this._localStorage) : super(_loadSavedLocale(_localStorage));

  final AppLocalStorage _localStorage;

  static Locale? _loadSavedLocale(AppLocalStorage storage) {
    final code = storage.getString(StorageKeys.locale);
    return code == null ? null : Locale(code);
  }

  String get languageCode =>
      state?.languageCode ??
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;

  void toggleLocale(Locale current) {
    final next = current.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    _localStorage.setString(StorageKeys.locale, next.languageCode);
    emit(next);
  }
}