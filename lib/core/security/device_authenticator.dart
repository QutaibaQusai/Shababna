import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

enum DeviceAuthResult { success, cancelled, unavailable, failed }

abstract interface class DeviceAuthenticator {
  Future<bool> isAvailable();

  Future<DeviceAuthResult> authenticate({required String reason});
}

class LocalDeviceAuthenticator implements DeviceAuthenticator {
  LocalDeviceAuthenticator(this._auth);

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } on LocalAuthException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<DeviceAuthResult> authenticate({required String reason}) async {
    try {
      final verified = await _auth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
      return verified ? DeviceAuthResult.success : DeviceAuthResult.failed;
    } on LocalAuthException catch (error) {
      return switch (error.code) {
        LocalAuthExceptionCode.userCanceled ||
        LocalAuthExceptionCode.systemCanceled ||
        LocalAuthExceptionCode.timeout ||
        LocalAuthExceptionCode.userRequestedFallback => DeviceAuthResult.cancelled,
        LocalAuthExceptionCode.noCredentialsSet ||
        LocalAuthExceptionCode.noBiometricsEnrolled ||
        LocalAuthExceptionCode.noBiometricHardware => DeviceAuthResult.unavailable,
        _ => DeviceAuthResult.failed,
      };
    } on PlatformException {
      return DeviceAuthResult.failed;
    }
  }
}
