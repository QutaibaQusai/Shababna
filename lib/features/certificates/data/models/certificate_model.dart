class CertificateModel {
  const CertificateModel({
    required this.id,
    required this.certificateNumber,
    required this.verificationCode,
    required this.titleEn,
    required this.titleAr,
    required this.volunteerNameEn,
    required this.volunteerNameAr,
    required this.recognizedHours,
    required this.periodStart,
    required this.periodEnd,
    required this.issuedAtUtc,
    required this.status,
    required this.isValid,
    required this.revokedAtUtc,
    required this.documentEnUrl,
    required this.documentArUrl,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] as String,
      certificateNumber: json['certificateNumber'] as String? ?? '',
      verificationCode: json['verificationCode'] as String? ?? '',
      titleEn: json['eventTitleEn'] as String? ?? '',
      titleAr: json['eventTitleAr'] as String? ?? '',
      volunteerNameEn: json['volunteerNameEn'] as String? ?? '',
      volunteerNameAr: json['volunteerNameAr'] as String? ?? '',
      recognizedHours: _parseDouble(json['recognizedHours']),
      periodStart: json['periodStart'] as String?,
      periodEnd: json['periodEnd'] as String?,
      issuedAtUtc: json['issuedAtUtc'] as String?,
      status: json['status'] as String? ?? '',
      isValid: json['isValid'] as bool? ?? true,
      revokedAtUtc: json['revokedAtUtc'] as String?,
      documentEnUrl: json['documentEnUrl'] as String? ?? '',
      documentArUrl: json['documentArUrl'] as String? ?? '',
    );
  }

  final String id;
  final String certificateNumber;
  final String verificationCode;
  final String titleEn;
  final String titleAr;
  final String volunteerNameEn;
  final String volunteerNameAr;
  final double recognizedHours;
  final String? periodStart;
  final String? periodEnd;
  final String? issuedAtUtc;
  final String status;
  final bool isValid;
  final String? revokedAtUtc;
  final String documentEnUrl;
  final String documentArUrl;

  static double _parseDouble(Object? value) => switch (value) {
    final num number => number.toDouble(),
    final String text => double.tryParse(text) ?? 0,
    _ => 0,
  };
}
