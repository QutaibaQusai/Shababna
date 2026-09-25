import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class Country {
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
}

class City {
  const City({required this.id, required this.nameAr, required this.nameEn});

  final String id;
  final String nameAr;
  final String nameEn;

  String displayName(bool isArabic) => isArabic ? nameAr : nameEn;
}

class Education {
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
}

class VolunteeringType {
  const VolunteeringType({required this.id, required this.nameAr, required this.nameEn});

  final String id;
  final String nameAr;
  final String nameEn;

  String displayName(bool isArabic) => isArabic ? nameAr : nameEn;
}

abstract interface class ProfileLookupsRepository {
  Future<Either<Failure, List<Country>>> getCountries();
  Future<Either<Failure, List<City>>> getCities();
  Future<Either<Failure, List<Education>>> getEducations();
  Future<Either<Failure, List<VolunteeringType>>> getVolunteeringTypes();
}
