import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

class Country extends Equatable {
  const Country({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.countryCode,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final String countryCode;

  String displayName(bool isArabic) => isArabic ? nameAr : nameEn;

  @override
  List<Object?> get props => [id];
}

class City extends Equatable {
  const City({required this.id, required this.nameAr, required this.nameEn});

  final String id;
  final String nameAr;
  final String nameEn;

  String displayName(bool isArabic) => isArabic ? nameAr : nameEn;

  @override
  List<Object?> get props => [id];
}

class Education extends Equatable {
  const Education({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.isMajorRequired,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final bool isMajorRequired;

  String displayName(bool isArabic) => isArabic ? nameAr : nameEn;

  @override
  List<Object?> get props => [id];
}

class VolunteeringType extends Equatable {
  const VolunteeringType({required this.id, required this.nameAr, required this.nameEn});

  final String id;
  final String nameAr;
  final String nameEn;

  String displayName(bool isArabic) => isArabic ? nameAr : nameEn;

  @override
  List<Object?> get props => [id];
}

class PhoneCode extends Equatable {
  const PhoneCode({
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

  @override
  List<Object?> get props => [countryCode, callingCode];
}

abstract interface class ProfileLookupsRepository {
  Future<Either<Failure, List<Country>>> getCountries();
  Future<Either<Failure, List<City>>> getCities();
  Future<Either<Failure, List<Education>>> getEducations();
  Future<Either<Failure, List<VolunteeringType>>> getVolunteeringTypes();
  Future<Either<Failure, List<PhoneCode>>> getPhoneCodes();
}
