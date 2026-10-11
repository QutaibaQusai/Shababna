import 'volunteering_opportunity_json_parsing.dart';

class VolunteeringOpportunityDonorModel {
  const VolunteeringOpportunityDonorModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory VolunteeringOpportunityDonorModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringOpportunityDonorModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String imageUrl;
}

class VolunteeringOpportunityImageModel {
  const VolunteeringOpportunityImageModel({required this.id, required this.url});

  factory VolunteeringOpportunityImageModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringOpportunityImageModel(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  final String id;
  final String url;
}

class VolunteeringOpportunityPropertyModel {
  const VolunteeringOpportunityPropertyModel({
    required this.labelEn,
    required this.labelAr,
    required this.valueEn,
    required this.valueAr,
  });

  factory VolunteeringOpportunityPropertyModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringOpportunityPropertyModel(
      labelEn: (json['labelEn'] as String? ?? '').trim(),
      labelAr: (json['labelAr'] as String? ?? '').trim(),
      valueEn: (json['valueEn'] as String? ?? '').trim(),
      valueAr: (json['valueAr'] as String? ?? '').trim(),
    );
  }

  final String labelEn;
  final String labelAr;
  final String valueEn;
  final String valueAr;
}

class VolunteeringOpportunityDetailsModel {
  const VolunteeringOpportunityDetailsModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.volunteeringOpportunityType,
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
  });

  factory VolunteeringOpportunityDetailsModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringOpportunityDetailsModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      volunteeringOpportunityType: VolunteeringOpportunityReferenceModel.fromJson(
        json['eventType'] as Map<String, dynamic>? ?? const {},
      ),
      from: json['from'] as String,
      to: json['to'] as String,
      address: json['address'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      ageFrom: parseVolunteeringOpportunityInt(json['ageFrom']),
      ageTo: parseVolunteeringOpportunityInt(json['ageTo']),
      hours: parseVolunteeringOpportunityInt(json['hours']),
      activitiesCount: parseVolunteeringOpportunityInt(json['activitiesCount']),
      volunteersCount: parseVolunteeringOpportunityInt(json['volunteersCount']),
      requiresApproval: json['requiresApproval'] as bool? ?? false,
      nationalities: parseVolunteeringOpportunityList(
        json['nationalities'],
        VolunteeringOpportunityReferenceModel.fromJson,
      ),
      cities: parseVolunteeringOpportunityList(
        json['cities'],
        VolunteeringOpportunityReferenceModel.fromJson,
      ),
      educations: parseVolunteeringOpportunityList(
        json['educations'],
        VolunteeringOpportunityReferenceModel.fromJson,
      ),
      imageUrl: json['imageUrl'] as String? ?? '',
      registrationStatus: json['registrationStatus'] as String? ?? '',
      donors: parseVolunteeringOpportunityList(
        json['donors'],
        VolunteeringOpportunityDonorModel.fromJson,
      ),
      images: parseVolunteeringOpportunityList(
        json['images'],
        VolunteeringOpportunityImageModel.fromJson,
      ),
      properties: parseVolunteeringOpportunityList(
        json['properties'],
        VolunteeringOpportunityPropertyModel.fromJson,
      ),
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final VolunteeringOpportunityReferenceModel volunteeringOpportunityType;
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
  final List<VolunteeringOpportunityReferenceModel> nationalities;
  final List<VolunteeringOpportunityReferenceModel> cities;
  final List<VolunteeringOpportunityReferenceModel> educations;
  final String imageUrl;
  final String registrationStatus;
  final List<VolunteeringOpportunityDonorModel> donors;
  final List<VolunteeringOpportunityImageModel> images;
  final List<VolunteeringOpportunityPropertyModel> properties;
}
