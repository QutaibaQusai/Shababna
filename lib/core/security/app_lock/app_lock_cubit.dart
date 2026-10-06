import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../session/auth_session_cubit.dart';
import '../../session/auth_status.dart';
import '../../storage/secure_storage.dart';
import '../../storage/storage_keys.dart';
import '../device_authenticator.dart';
import 'app_lock_state.dart';

class AppLockCubit extends Cubit<AppLockState> {
  AppLockCubit(
    this._authenticator,
    this._storage,
    this._authSession, {
    required bool isEnabled,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now,
       super(
         AppLockState(
           isEnabled: isEnabled && _authSession.state.isAuthenticated,
           isLocked: isEnabled && _authSession.state.isAuthenticated,
         ),
       ) {
    _autoPromptPending = state.isLocked;
    if (isEnabled && !_authSession.state.isAuthenticated) _disable();
    _sessionSubscription = _authSession.stream.listen((status) {
      if (!status.isAuthenticated) _disable();
    });
  }

  static const lockGrace = Duration(seconds: 30);
  static const _enabledValue = 'true';

  final DeviceAuthenticator _authenticator;
  final AppSecureStorage _storage;
  final AuthSessionCubit _authSession;
  final DateTime Function() _now;
  late final StreamSubscription<AuthStatus> _sessionSubscription;

  DateTime? _hiddenAt;
  bool _autoPromptPending = false;

  bool get _isGuarding => state.isEnabled && _authSession.state.isAuthenticated;

  Future<void> refreshAvailability() async {
    final isAvailable = await _authenticator.isAvailable();
    if (isClosed) return;
    emit(state.copyWith(isAvailable: isAvailable));
  }

  Future<DeviceAuthResult> setEnabled(bool value, {required String reason}) async {
    if (value == state.isEnabled || state.isAuthenticating) return DeviceAuthResult.cancelled;

    final isAvailable = await _authenticator.isAvailable();
    if (isClosed) return DeviceAuthResult.cancelled;
    emit(state.copyWith(isAvailable: isAvailable));

    if (!isAvailable) {
      if (value) return DeviceAuthResult.unavailable;
      await _disable();
      return DeviceAuthResult.success;
    }

    final result = await _verify(reason);
    if (result != DeviceAuthResult.success || isClosed) return result;

    if (value) {
      await _storage.write(StorageKeys.appLockEnabled, _enabledValue);
      if (!isClosed) emit(state.copyWith(isEnabled: true));
    } else {
      await _disable();
    }
    return result;
  }

  Future<void> unlock({required String reason}) async {
    if (!state.isLocked || state.isAuthenticating) return;
    _autoPromptPending = false;
    emit(state.copyWith(unlockResult: () => null));

    final result = await _verify(reason);
    if (isClosed || !state.isLocked) return;
    emit(state.copyWith(isLocked: result != DeviceAuthResult.success, unlockResult: () => result));
  }

  void appHidden() {
    if (!_isGuarding || state.isAuthenticating || state.isLocked) return;
    _hiddenAt ??= _now();
  }

  void appShown() {
    final hiddenAt = _hiddenAt;
    _hiddenAt = null;
    if (hiddenAt == null || !_isGuarding || state.isLocked) return;
    if (_now().difference(hiddenAt) < lockGrace) return;
    _autoPromptPending = true;
    emit(state.copyWith(isLocked: true, unlockResult: () => null));
  }

  Future<void> appResumed({required String reason}) async {
    if (!_autoPromptPending || !state.isLocked) return;
    await unlock(reason: reason);
  }

  Future<DeviceAuthResult> _verify(String reason) async {
    emit(state.copyWith(isAuthenticating: true));
    final result = await _authenticator.authenticate(reason: reason);
    if (!isClosed) emit(state.copyWith(isAuthenticating: false));
    return result;
  }

  Future<void> _disable() async {
    _hiddenAt = null;
    _autoPromptPending = false;
    await _storage.delete(StorageKeys.appLockEnabled);
    if (isClosed) return;
    emit(state.copyWith(isEnabled: false, isLocked: false, unlockResult: () => null));
  }

  @override
  Future<void> close() {
    _sessionSubscription.cancel();
    return super.close();
  }
}
