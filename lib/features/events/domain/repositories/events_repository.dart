import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';

enum EventGender { male, female, both }

enum EventRegistrationStatus { notRegistered, pendingApproval, approved, withdrawn, rejected }

class EventReference extends Equatable {
  const EventReference({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class EventDonor extends Equatable {
  const EventDonor({required this.id, required this.title, required this.imageUrl});

  final String id;
  final String title;
  final String imageUrl;

  @override
  List<Object?> get props => [id, title, imageUrl];
}

class EventSummary extends Equatable {
  const EventSummary({
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
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final EventReference type;
  final DateTime from;
  final DateTime to;
  final String address;
  final EventGender gender;
  final int ageFrom;
  final int ageTo;
  final int hours;
  final int volunteersCount;
  final bool requiresApproval;
  final String imageUrl;

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
      ];
}

class EventDetails extends Equatable {
  const EventDetails({
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
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final EventReference type;
  final DateTime from;
  final DateTime to;
  final String address;
  final EventGender gender;
  final int ageFrom;
  final int ageTo;
  final int hours;
  final int activitiesCount;
  final int volunteersCount;
  final bool requiresApproval;
  final List<EventReference> nationalities;
  final List<EventReference> cities;
  final List<EventReference> educations;
  final String imageUrl;
  final EventRegistrationStatus registrationStatus;
  final List<EventDonor> donors;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  String description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;

  bool get hasEnded {
    final now = DateTime.now();
    return to.isBefore(DateTime(now.year, now.month, now.day));
  }

  EventDetails copyWith({EventRegistrationStatus? registrationStatus}) {
    return EventDetails(
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
      ];
}

class EventRegistrationResult extends Equatable {
  const EventRegistrationResult({required this.registrationStatus, required this.message});

  final EventRegistrationStatus registrationStatus;
  final String message;

  @override
  List<Object?> get props => [registrationStatus, message];
}

abstract interface class EventsRepository {
  Future<Either<Failure, PagedResult<EventSummary>>> getEvents({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, EventDetails>> getEventById(String id);

  Future<Either<Failure, EventRegistrationResult>> register(
    String id, {
    required String idempotencyKey,
  });

  Future<Either<Failure, EventRegistrationResult>> withdraw(String id);
}
