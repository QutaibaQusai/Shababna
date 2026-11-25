import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/device_identity_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../domain/auth_identifier.dart';
import '../../domain/login_verification.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/verification_channel.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/check_registration_request_model.dart';
import '../models/email_request_model.dart';
import '../models/login_request_model.dart';
import '../models/pending_verification_model.dart';
import '../models/register_request_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/send_otp_request_model.dart';
import '../models/token_response_model.dart';
import '../models/verify_otp_request_model.dart';
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
  Future<Either<Failure, LoginOutcome>> login({
    required AuthIdentifier identifier,
    required String password,
  }) async {
    final result = await guard<LoginOutcome>(() async {
      final deviceId = await _deviceIdentityService.getOrCreateDeviceId();
      final tokens = await _remoteDataSource.login(
        LoginRequestModel(
          identifier: identifier.value,
          password: password,
          deviceId: deviceId,
          deviceName: _deviceIdentityService.deviceName,
        ),
      );
      await _saveTokens(tokens);
      return const LoginSucceeded();
    });

    return result.fold<Either<Failure, LoginOutcome>>((failure) {
      if (!AuthErrorCodes.notVerified.contains(failure.code)) return Left(failure);
      final pending = PendingVerificationModel.fromProblemExtensions(
        failure.extensions,
        fallbackChannel: identifier.channel,
      );
      return pending == null
          ? Left(failure)
          : Right(LoginNeedsVerification(pending, message: failure.displayMessage));
    }, (outcome) => Right(outcome));
  }

  @override
  Future<Either<Failure, int>> sendLoginCode(PendingVerification pending) {
    return guard(() async {
      final response = await _remoteDataSource.sendOtp(
        SendOtpRequestModel(channel: pending.channel, verificationToken: pending.token),
      );
      return response.resendAfterSeconds;
    });
  }

  @override
  Future<Either<Failure, void>> verifyLoginCode({
    required PendingVerification pending,
    required String code,
  }) {
    return guard(() async {
      final deviceId = await _deviceIdentityService.getOrCreateDeviceId();
      final response = await _remoteDataSource.verifyOtp(
        VerifyOtpRequestModel(
          channel: pending.channel,
          code: code,
          verificationToken: pending.token,
          deviceId: deviceId,
          deviceName: _deviceIdentityService.deviceName,
        ),
      );
      final tokens = response.tokens;
      if (tokens == null) {
        throw const ServerException('Sign-in could not be completed. Please try again.');
      }
      await _saveTokens(tokens);
    });
  }

  Future<void> _saveTokens(TokenResponseModel tokens) async {
    await _secureStorage.write(StorageKeys.accessToken, tokens.accessToken);
    await _secureStorage.write(StorageKeys.refreshToken, tokens.refreshToken);
  }

  @override
  Future<Either<Failure, String>> checkRegistration({
    required String email,
    required String phoneNumber,
    required VerificationChannel channel,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.checkRegistration(
        CheckRegistrationRequestModel(email: email, phoneNumber: phoneNumber, channel: channel),
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
