import 'lookup_json.dart';

class EducationModel {
  const EducationModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.isMajorRequired,
    required this.order,
    required this.isActive,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      isMajorRequired: json['isMajorRequired'] as bool? ?? false,
      order: parseLookupInt(json['order']),
      isActive: parseIsActive(json['isActive']),
    );
  }

  final String id;
  final String nameAr;
  final String nameEn;
  final bool isMajorRequired;
  final int order;
  final bool isActive;
}
