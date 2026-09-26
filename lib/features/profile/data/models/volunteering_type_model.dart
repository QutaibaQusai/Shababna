import 'lookup_json.dart';

class VolunteeringTypeModel {
  const VolunteeringTypeModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.order,
    required this.isActive,
  });

  factory VolunteeringTypeModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringTypeModel(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      order: parseLookupInt(json['order']),
      isActive: parseIsActive(json['isActive']),
    );
  }

  final String id;
  final String nameAr;
  final String nameEn;
  final int order;
  final bool isActive;
}
