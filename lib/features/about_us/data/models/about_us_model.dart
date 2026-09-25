class AboutUsModel {
  const AboutUsModel({
    required this.aboutUsEn,
    required this.aboutUsAr,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      aboutUsEn: json['aboutUsEn'] as String,
      aboutUsAr: json['aboutUsAr'] as String,
    );
  }

  final String aboutUsEn;
  final String aboutUsAr;
}
