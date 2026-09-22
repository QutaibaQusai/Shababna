class LegalContentModel {
  const LegalContentModel({
    required this.privacyPolicyEn,
    required this.privacyPolicyAr,
    required this.termsAndConditionsEn,
    required this.termsAndConditionsAr,
  });

  factory LegalContentModel.fromJson(Map<String, dynamic> json) {
    return LegalContentModel(
      privacyPolicyEn: json['privacyPolicyEn'] as String,
      privacyPolicyAr: json['privacyPolicyAr'] as String,
      termsAndConditionsEn: json['termsAndConditionsEn'] as String,
      termsAndConditionsAr: json['termsAndConditionsAr'] as String,
    );
  }

  final String privacyPolicyEn;
  final String privacyPolicyAr;
  final String termsAndConditionsEn;
  final String termsAndConditionsAr;
}
