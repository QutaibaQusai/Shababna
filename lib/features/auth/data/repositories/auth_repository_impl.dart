import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/device_identity_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/check_registration_request_model.dart';
import '../models/email_request_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/verify_registration_code_request_model.dart';
import '../models/verify_reset_code_request_model.dart';

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
  Future<Either<Failure, String>> checkRegistration({
    required String email,
    required String phoneNumber,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.checkRegistration(
        CheckRegistrationRequestModel(email: email, phoneNumber: phoneNumber),
      );
      return response.message;
    });
  }

  @override
  Future<Either<Failure, String>> verifyRegistrationCode({
    required String email,
    required String phoneNumber,
    required String code,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.verifyRegistrationCode(
        VerifyRegistrationCodeRequestModel(email: email, phoneNumber: phoneNumber, code: code),
      );
      return response.verificationToken;
    });
  }

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String phoneNumber,
    required String fullName,
    required String password,
    required String confirmPassword,
    required String verificationToken,
  }) {
    return guard(() async {
      await _remoteDataSource.register(
        RegisterRequestModel(
          email: email,
          phoneNumber: phoneNumber,
          fullName: fullName,
          password: password,
          confirmPassword: confirmPassword,
          verificationToken: verificationToken,
        ),
      );
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
  Future<Either<Failure, String>> verifyResetCode({
    required String email,
    required String code,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.verifyResetCode(
        VerifyResetCodeRequestModel(email: email, code: code),
      );
      return response.resetToken;
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) {
    return guard(() {
      return _remoteDataSource.resetPassword(
        ResetPasswordRequestModel(
          email: email,
          resetToken: resetToken,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ),
      );
    });
  }

  @override
  Future<Either<Failure, List<CountryPhoneCode>>> getPhoneCodes() {
    return guard(() async {
      final response = await _remoteDataSource.getPhoneCodes();
      return response
          .map((item) => CountryPhoneCode(
                countryName: item.countryName,
                countryCode: item.countryCode,
                callingCode: item.callingCode,
                flag: item.flag,
                nationalNumberLength: item.nationalNumberLength,
                mobilePrefixes: item.mobilePrefixes,
              ))
          .toList();
    });
  }

  @override
  Future<Either<Failure, void>> logout() {
    return guard(() => _remoteDataSource.logout());
  }
}
