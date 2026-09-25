class CountryModel {
  const CountryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.countryCode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      countryCode: json['countryCode'] as String,
    );
  }

  final String id;
  final String nameAr;
  final String nameEn;
  final String countryCode;
}
