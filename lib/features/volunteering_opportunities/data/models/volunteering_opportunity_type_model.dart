import 'volunteering_opportunity_json_parsing.dart';

class VolunteeringOpportunityTypeModel {
  const VolunteeringOpportunityTypeModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.order,
    required this.isActive,
    required this.volunteeringOpportunitiesCount,
  });

  factory VolunteeringOpportunityTypeModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringOpportunityTypeModel(
      id: json['id'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      order: parseVolunteeringOpportunityInt(json['order']),
      isActive: json['isActive'] as bool? ?? true,
      volunteeringOpportunitiesCount: parseVolunteeringOpportunityInt(json['eventsCount']),
    );
  }

  final String id;
  final String nameEn;
  final String nameAr;
  final int order;
  final bool isActive;
  final int volunteeringOpportunitiesCount;
}
