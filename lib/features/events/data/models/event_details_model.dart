import 'event_json_parsing.dart';

class EventDonorModel {
  const EventDonorModel({required this.id, required this.title, required this.imageUrl});

  factory EventDonorModel.fromJson(Map<String, dynamic> json) {
    return EventDonorModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String imageUrl;
}

class EventImageModel {
  const EventImageModel({required this.id, required this.url});

  factory EventImageModel.fromJson(Map<String, dynamic> json) {
    return EventImageModel(id: json['id'] as String? ?? '', url: json['url'] as String? ?? '');
  }

  final String id;
  final String url;
}

class EventDetailsModel {
  const EventDetailsModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.eventType,
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
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) {
    return EventDetailsModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      eventType: EventReferenceModel.fromJson(
        json['eventType'] as Map<String, dynamic>? ?? const {},
      ),
      from: json['from'] as String,
      to: json['to'] as String,
      address: json['address'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      ageFrom: parseEventInt(json['ageFrom']),
      ageTo: parseEventInt(json['ageTo']),
      hours: parseEventInt(json['hours']),
      activitiesCount: parseEventInt(json['activitiesCount']),
      volunteersCount: parseEventInt(json['volunteersCount']),
      requiresApproval: json['requiresApproval'] as bool? ?? false,
      nationalities: parseEventList(json['nationalities'], EventReferenceModel.fromJson),
      cities: parseEventList(json['cities'], EventReferenceModel.fromJson),
      educations: parseEventList(json['educations'], EventReferenceModel.fromJson),
      imageUrl: json['imageUrl'] as String? ?? '',
      registrationStatus: json['registrationStatus'] as String? ?? '',
      donors: parseEventList(json['donors'], EventDonorModel.fromJson),
      images: parseEventList(json['images'], EventImageModel.fromJson),
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final EventReferenceModel eventType;
  final String from;
  final String to;
  final String address;
  final String gender;
  final int ageFrom;
  final int ageTo;
  final int hours;
  final int activitiesCount;
  final int volunteersCount;
  final bool requiresApproval;
  final List<EventReferenceModel> nationalities;
  final List<EventReferenceModel> cities;
  final List<EventReferenceModel> educations;
  final String imageUrl;
  final String registrationStatus;
  final List<EventDonorModel> donors;
  final List<EventImageModel> images;
}
