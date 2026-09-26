import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../storage/storage_keys.dart';
import 'auth_status.dart';

class AuthSessionCubit extends Cubit<AuthStatus> {
  AuthSessionCubit(this._secureStorage, this._localStorage, {required AuthStatus initialStatus})
      : super(initialStatus);

  final AppSecureStorage _secureStorage;
  final AppLocalStorage _localStorage;

  Future<void> markAuthenticated() async {
    await _localStorage.remove(StorageKeys.guestMode);
    emit(AuthStatus.authenticated);
  }

  Future<void> continueAsGuest() async {
    await _clearTokens();
    await _localStorage.setBool(StorageKeys.guestMode, true);
    emit(AuthStatus.guest);
  }

  Future<void> markUnauthenticated() async {
    await _clearTokens();
    await _localStorage.remove(StorageKeys.guestMode);
    emit(AuthStatus.unauthenticated);
  }

  Future<void> expireSession() async {
    if (state.isGuest) return;
    await markUnauthenticated();
  }

  Future<void> _clearTokens() async {
    await _secureStorage.delete(StorageKeys.accessToken);
    await _secureStorage.delete(StorageKeys.refreshToken);
  }
}
