import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/device_identity_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/email_request_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/verify_email_request_model.dart';

class AuthRepositoryImpl with RepositoryGuardMixin implements AuthRepository {
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._secureStorage,
    this._deviceIdentityService,
  );

  final AuthRemoteDataSource _remoteDataSource;
  final AppSecureStorage _secureStorage;
  final DeviceIdentityService _deviceIdentityService;

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) {
    return guard(() async {
      final deviceId = await _deviceIdentityService.getOrCreateDeviceId();
      final tokens = await _remoteDataSource.login(
        LoginRequestModel(
          email: email,
          password: password,
          deviceId: deviceId,
          deviceName: _deviceIdentityService.deviceName,
        ),
      );
      await _secureStorage.write(StorageKeys.accessToken, tokens.accessToken);
      await _secureStorage.write(StorageKeys.refreshToken, tokens.refreshToken);
    });
  }

  @override
  Future<Either<Failure, RegisterResult>> register({
    required String email,
    required String phoneNumber,
    required String fullNameEn,
    required String fullNameAr,
    required String password,
    required String confirmPassword,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.register(
        RegisterRequestModel(
          email: email,
          phoneNumber: phoneNumber,
          fullNameEn: fullNameEn,
          fullNameAr: fullNameAr,
          password: password,
          confirmPassword: confirmPassword,
        ),
      );
      return RegisterResult(
        email: response.email,
        emailVerificationRequired: response.emailVerificationRequired,
      );
    });
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String code,
  }) {
    return guard(() {
      return _remoteDataSource.verifyEmail(
        VerifyEmailRequestModel(email: email, code: code),
      );
    });
  }

  @override
  Future<Either<Failure, String>> resendEmailVerification({
    required String email,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.resendEmailVerification(
        EmailRequestModel(email: email),
      );
      return response.message;
    });
  }

  @override
  Future<Either<Failure, String>> forgotPassword({required String email}) {
    return guard(() async {
      final response = await _remoteDataSource.forgotPassword(
        EmailRequestModel(email: email),
      );
      return response.message;
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) {
    return guard(() {
      return _remoteDataSource.resetPassword(
        ResetPasswordRequestModel(
          email: email,
          code: code,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ),
      );
    });
  }
}
