import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class RegisterResult {
  const RegisterResult({required this.email, required this.emailVerificationRequired});

  final String email;
  final bool emailVerificationRequired;
}

class CountryPhoneCode {
  const CountryPhoneCode({
    required this.countryName,
    required this.countryCode,
    required this.callingCode,
    required this.flag,
  });

  final String countryName;
  final String countryCode;
  final String callingCode;
  final String flag;
}

abstract interface class AuthRepository {
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, RegisterResult>> register({
    required String email,
    required String phoneNumber,
    required String fullNameEn,
    required String fullNameAr,
    required String password,
    required String confirmPassword,
  });

  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String code,
  });

  Future<Either<Failure, String>> resendEmailVerification({
    required String email,
  });

  Future<Either<Failure, String>> forgotPassword({required String email});

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Either<Failure, List<CountryPhoneCode>>> getPhoneCodes();
}
