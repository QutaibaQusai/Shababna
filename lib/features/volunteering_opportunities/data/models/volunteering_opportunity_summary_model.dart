import 'volunteering_opportunity_json_parsing.dart';

class VolunteeringOpportunitySummaryModel {
  const VolunteeringOpportunitySummaryModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.volunteeringOpportunityType,
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

  factory VolunteeringOpportunitySummaryModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringOpportunitySummaryModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
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
      volunteersCount: parseVolunteeringOpportunityInt(json['volunteersCount']),
      requiresApproval: json['requiresApproval'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final VolunteeringOpportunityReferenceModel volunteeringOpportunityType;
  final String from;
  final String to;
  final String address;
  final String gender;
  final int ageFrom;
  final int ageTo;
  final int hours;
  final int volunteersCount;
  final bool requiresApproval;
  final String imageUrl;
}
