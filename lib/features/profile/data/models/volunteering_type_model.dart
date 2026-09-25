class VolunteeringTypeModel {
  const VolunteeringTypeModel({required this.id, required this.nameAr, required this.nameEn});

  factory VolunteeringTypeModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringTypeModel(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
    );
  }

  final String id;
  final String nameAr;
  final String nameEn;
}
