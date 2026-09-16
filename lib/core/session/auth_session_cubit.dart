import 'package:flutter_bloc/flutter_bloc.dart';

import '../storage/secure_storage.dart';
import '../storage/storage_keys.dart';
import 'auth_status.dart';

class AuthSessionCubit extends Cubit<AuthStatus> {
  AuthSessionCubit(this._secureStorage, {required AuthStatus initialStatus})
      : super(initialStatus);

  final AppSecureStorage _secureStorage;

  void markAuthenticated() => emit(AuthStatus.authenticated);

  Future<void> markUnauthenticated() async {
    await _secureStorage.delete(StorageKeys.accessToken);
    await _secureStorage.delete(StorageKeys.refreshToken);
    emit(AuthStatus.unauthenticated);
  }
}
