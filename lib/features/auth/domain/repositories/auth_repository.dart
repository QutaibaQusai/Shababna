import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class CountryPhoneCode {
  const CountryPhoneCode({
    required this.countryName,
    required this.countryCode,
    required this.callingCode,
    required this.flag,
    this.nationalNumberLength,
    this.mobilePrefixes,
  });

  final String countryName;
  final String countryCode;
  final String callingCode;
  final String flag;
  final int? nationalNumberLength;
  final List<String>? mobilePrefixes;
}

abstract interface class AuthRepository {
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> checkRegistration({
    required String email,
    required String phoneNumber,
  });

  Future<Either<Failure, String>> verifyRegistrationCode({
    required String email,
    required String code,
  });

  Future<Either<Failure, void>> register({
    required String email,
    required String phoneNumber,
    required String fullNameEn,
    required String fullNameAr,
    required String password,
    required String confirmPassword,
    required String verificationToken,
  });

  Future<Either<Failure, String>> forgotPassword({required String email});

  Future<Either<Failure, String>> verifyResetCode({
    required String email,
    required String code,
  });

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Either<Failure, List<CountryPhoneCode>>> getPhoneCodes();

  Future<Either<Failure, void>> logout();
}
