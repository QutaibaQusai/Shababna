import 'lookup_json.dart';

class CityModel {
  const CityModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.isActive,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      isActive: parseIsActive(json['isActive']),
    );
  }

  final String id;
  final String nameAr;
  final String nameEn;
  final bool isActive;
}
