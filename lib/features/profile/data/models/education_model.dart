class EducationModel {
  const EducationModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.isMajorRequired,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      isMajorRequired: json['isMajorRequired'] as bool,
    );
  }

  final String id;
  final String nameAr;
  final String nameEn;
  final bool isMajorRequired;
}
