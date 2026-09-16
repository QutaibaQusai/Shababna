import 'dart:io';

import 'package:uuid/uuid.dart';

import '../storage/local_storage.dart';
import '../storage/storage_keys.dart';

class DeviceIdentityService {
  DeviceIdentityService(this._localStorage);

  final AppLocalStorage _localStorage;

  Future<String> getOrCreateDeviceId() async {
    final existing = _localStorage.getString(StorageKeys.deviceId);
    if (existing != null) return existing;

    final generated = const Uuid().v4();
    await _localStorage.setString(StorageKeys.deviceId, generated);
    return generated;
  }

  String get deviceName => Platform.operatingSystem;
}
