import 'dart:async';
import 'dart:io';

import '../../../../core/logging/app_logger.dart';
import '../../../../core/notifications/notification_permission_service.dart';
import '../../../../core/notifications/push_device_registrar.dart';
import '../../../../core/notifications/push_notification_service.dart';
import '../../../../core/services/device_identity_service.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/session/auth_session_cubit.dart';
import '../repositories/notifications_repository.dart';

typedef _Registration = ({String token, String language, bool isMember});

class PushRegistrationCoordinator implements PushDeviceRegistrar {
  PushRegistrationCoordinator(
    this._repository,
    this._push,
    this._permission,
    this._deviceIdentity,
    this._session,
    this._locale,
    this._logger,
  );

  static const _tag = 'PushRegistration';
  static const _arabic = 'ar';
  static const _english = 'en';

  final NotificationsRepository _repository;
  final PushNotificationService _push;
  final NotificationPermissionService _permission;
  final DeviceIdentityService _deviceIdentity;
  final AuthSessionCubit _session;
  final LocaleService _locale;
  final AppLogger _logger;
  final _subscriptions = <StreamSubscription<Object?>>[];

  Future<void> _queue = Future.value();
  _Registration? _registered;
  bool _started = false;

  void start() {
    if (_started) return;
    _started = true;
    _subscriptions
      ..add(_session.stream.listen((_) => refresh()))
      ..add(_locale.stream.listen((_) => refresh()))
      ..add(_push.onTokenRefresh.listen((_) => refresh()));
    refresh();
  }

  @override
  Future<void> refresh({bool force = false}) {
    final run = _queue.then((_) => _sync(force: force));
    _queue = run;
    return run;
  }

  Future<void> _sync({required bool force}) async {
    try {
      final permission = await _permission.current();
      if (permission != NotificationPermissionStatus.granted) return;

      final token = await _push.getToken();
      if (token == null) return;

      final registration = (
        token: token,
        language: _locale.languageCode == _arabic ? _arabic : _english,
        isMember: _session.state.isAuthenticated,
      );
      if (!force && registration == _registered) return;

      final result = await _repository.registerDevice(
        token: registration.token,
        deviceId: await _deviceIdentity.getOrCreateDeviceId(),
        platform: Platform.isIOS ? DevicePlatform.ios : DevicePlatform.android,
        language: registration.language,
      );
      result.fold(
        (failure) => _logger.warning(
          'Push device registration failed (${failure.code ?? failure.runtimeType})',
          tag: _tag,
        ),
        (_) {
          _registered = registration;
          _logger.info(
            'Push device registered as ${registration.isMember ? 'member' : 'guest'}',
            tag: _tag,
          );
        },
      );
    } catch (error) {
      _logger.warning(
        'Push device registration failed (${error.runtimeType})',
        tag: _tag,
      );
    }
  }
}
