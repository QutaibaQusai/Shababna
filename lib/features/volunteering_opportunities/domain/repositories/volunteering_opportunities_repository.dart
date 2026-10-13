import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';

enum VolunteeringOpportunityGender { male, female, both }

enum VolunteeringOpportunityRegistrationStatus {
  notRegistered,
  pendingApproval,
  approved,
  withdrawn,
  rejected,
}

class VolunteeringOpportunityReference extends Equatable {
  const VolunteeringOpportunityReference({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class VolunteeringOpportunityType extends Equatable {
  const VolunteeringOpportunityType({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.volunteeringOpportunitiesCount,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final int volunteeringOpportunitiesCount;

  String name(bool isArabic) => isArabic ? nameAr : nameEn;

  bool get hasVolunteeringOpportunities => volunteeringOpportunitiesCount > 0;

  @override
  List<Object?> get props => [id, nameEn, nameAr, volunteeringOpportunitiesCount];
}

class VolunteeringOpportunityDonor extends Equatable {
  const VolunteeringOpportunityDonor({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String imageUrl;

  @override
  List<Object?> get props => [id, title, imageUrl];
}

class VolunteeringOpportunityImage extends Equatable {
  const VolunteeringOpportunityImage({required this.id, required this.url});

  final String id;
  final String url;

  @override
  List<Object?> get props => [id, url];
}

class VolunteeringOpportunityProperty extends Equatable {
  const VolunteeringOpportunityProperty({
    required this.labelEn,
    required this.labelAr,
    required this.valueEn,
    required this.valueAr,
  });

  final String labelEn;
  final String labelAr;
  final String valueEn;
  final String valueAr;

  String label(bool isArabic) => _localized(isArabic, en: labelEn, ar: labelAr);

  String value(bool isArabic) => _localized(isArabic, en: valueEn, ar: valueAr);

  bool get isComplete =>
      (labelEn.isNotEmpty || labelAr.isNotEmpty) && (valueEn.isNotEmpty || valueAr.isNotEmpty);

  static String _localized(bool isArabic, {required String en, required String ar}) {
    final preferred = isArabic ? ar : en;
    return preferred.isNotEmpty ? preferred : (isArabic ? en : ar);
  }

  @override
  List<Object?> get props => [labelEn, labelAr, valueEn, valueAr];
}

class VolunteeringOpportunitySummary extends Equatable {
  const VolunteeringOpportunitySummary({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.type,
    required this.from,
    required this.to,
    required this.address,
    required this.gender,
    required this.ageFrom,
    required this.ageTo,
    required this.hours,
    required this.volunteersCount,
    required this.requiresApproval,
    required this.imageUrl,
    required this.hasEnded,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final VolunteeringOpportunityReference type;
  final DateTime from;
  final DateTime to;
  final String address;
  final VolunteeringOpportunityGender gender;
  final int ageFrom;
  final int ageTo;
  final int hours;
  final int volunteersCount;
  final bool requiresApproval;
  final String imageUrl;
  final bool hasEnded;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  @override
  List<Object?> get props => [
    id,
    titleEn,
    titleAr,
    type,
    from,
    to,
    address,
    gender,
    ageFrom,
    ageTo,
    hours,
    volunteersCount,
    requiresApproval,
    imageUrl,
    hasEnded,
  ];
}

class VolunteeringOpportunityDetails extends Equatable {
  const VolunteeringOpportunityDetails({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.type,
    required this.from,
    required this.to,
    required this.address,
    required this.gender,
    required this.ageFrom,
    required this.ageTo,
    required this.hours,
    required this.activitiesCount,
    required this.volunteersCount,
    required this.requiresApproval,
    required this.nationalities,
    required this.cities,
    required this.educations,
    required this.imageUrl,
    required this.registrationStatus,
    required this.donors,
    required this.images,
    required this.properties,
    required this.hasEnded,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final VolunteeringOpportunityReference type;
  final DateTime from;
  final DateTime to;
  final String address;
  final VolunteeringOpportunityGender gender;
  final int ageFrom;
  final int ageTo;
  final int hours;
  final int activitiesCount;
  final int volunteersCount;
  final bool requiresApproval;
  final List<VolunteeringOpportunityReference> nationalities;
  final List<VolunteeringOpportunityReference> cities;
  final List<VolunteeringOpportunityReference> educations;
  final String imageUrl;
  final VolunteeringOpportunityRegistrationStatus registrationStatus;
  final List<VolunteeringOpportunityDonor> donors;
  final List<VolunteeringOpportunityImage> images;
  final List<VolunteeringOpportunityProperty> properties;
  final bool hasEnded;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  String description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;

  VolunteeringOpportunityDetails copyWith({
    VolunteeringOpportunityRegistrationStatus? registrationStatus,
  }) {
    return VolunteeringOpportunityDetails(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      type: type,
      from: from,
      to: to,
      address: address,
      gender: gender,
      ageFrom: ageFrom,
      ageTo: ageTo,
      hours: hours,
      activitiesCount: activitiesCount,
      volunteersCount: volunteersCount,
      requiresApproval: requiresApproval,
      nationalities: nationalities,
      cities: cities,
      educations: educations,
      imageUrl: imageUrl,
      registrationStatus: registrationStatus ?? this.registrationStatus,
      donors: donors,
      images: images,
      properties: properties,
      hasEnded: hasEnded,
    );
  }

  @override
  List<Object?> get props => [
    id,
    titleEn,
    titleAr,
    descriptionEn,
    descriptionAr,
    type,
    from,
    to,
    address,
    gender,
    ageFrom,
    ageTo,
    hours,
    activitiesCount,
    volunteersCount,
    requiresApproval,
    nationalities,
    cities,
    educations,
    imageUrl,
    registrationStatus,
    donors,
    images,
    properties,
    hasEnded,
  ];
}

class VolunteeringOpportunityRegistrationResult extends Equatable {
  const VolunteeringOpportunityRegistrationResult({
    required this.registrationStatus,
    required this.message,
  });

  final VolunteeringOpportunityRegistrationStatus registrationStatus;
  final String message;

  @override
  List<Object?> get props => [registrationStatus, message];
}

abstract interface class VolunteeringOpportunitiesRepository {
  Future<Either<Failure, PagedResult<VolunteeringOpportunitySummary>>>
  getVolunteeringOpportunities({
    required int page,
    required int pageSize,
    String? typeId,
    DateTime? date,
  });

  Future<Either<Failure, List<VolunteeringOpportunityType>>> getVolunteeringOpportunityTypes();

  Future<Either<Failure, VolunteeringOpportunityDetails>> getVolunteeringOpportunityById(String id);

  Future<Either<Failure, VolunteeringOpportunityRegistrationResult>> register(
    String id, {
    required String idempotencyKey,
  });

  Future<Either<Failure, VolunteeringOpportunityRegistrationResult>> withdraw(String id);
}
