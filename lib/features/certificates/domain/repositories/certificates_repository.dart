import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';

enum CertificateLanguage { arabic, english }

class Certificate extends Equatable {
  const Certificate({
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
    required this.issuedAt,
    required this.isRevoked,
    required this.revokedAt,
    required this.documentEnUrl,
    required this.documentArUrl,
  });

  final String id;
  final String certificateNumber;
  final String verificationCode;
  final String titleEn;
  final String titleAr;
  final String volunteerNameEn;
  final String volunteerNameAr;
  final double recognizedHours;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime? issuedAt;
  final bool isRevoked;
  final DateTime? revokedAt;
  final String documentEnUrl;
  final String documentArUrl;

  String title(bool isArabic) => _localized(isArabic, en: titleEn, ar: titleAr);

  String volunteerName(bool isArabic) =>
      _localized(isArabic, en: volunteerNameEn, ar: volunteerNameAr);

  String documentUrl(CertificateLanguage language) => switch (language) {
    CertificateLanguage.arabic => documentArUrl,
    CertificateLanguage.english => documentEnUrl,
  };

  List<CertificateLanguage> get availableLanguages => [
    for (final language in CertificateLanguage.values)
      if (documentUrl(language).isNotEmpty) language,
  ];

  static String _localized(bool isArabic, {required String en, required String ar}) {
    final preferred = isArabic ? ar : en;
    return preferred.isNotEmpty ? preferred : (isArabic ? en : ar);
  }

  @override
  List<Object?> get props => [
    id,
    certificateNumber,
    verificationCode,
    titleEn,
    titleAr,
    volunteerNameEn,
    volunteerNameAr,
    recognizedHours,
    periodStart,
    periodEnd,
    issuedAt,
    isRevoked,
    revokedAt,
    documentEnUrl,
    documentArUrl,
  ];
}

abstract interface class CertificatesRepository {
  Future<Either<Failure, PagedResult<Certificate>>> getCertificates({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, Certificate>> getCertificate(String id);

  Future<Either<Failure, String>> downloadDocument(
    Certificate certificate,
    CertificateLanguage language,
  );
}
