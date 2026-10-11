import '../../domain/repositories/certificates_repository.dart';
import '../models/certificate_model.dart';

extension CertificateModelMapper on CertificateModel {
  static const _revokedStatus = 'Revoked';

  Certificate toEntity() {
    return Certificate(
      id: id,
      certificateNumber: certificateNumber,
      verificationCode: verificationCode,
      titleEn: titleEn,
      titleAr: titleAr,
      volunteerNameEn: volunteerNameEn,
      volunteerNameAr: volunteerNameAr,
      recognizedHours: recognizedHours,
      periodStart: _localDate(periodStart),
      periodEnd: _localDate(periodEnd),
      issuedAt: _localDate(issuedAtUtc),
      isRevoked: status == _revokedStatus || !isValid,
      revokedAt: _localDate(revokedAtUtc),
      documentEnUrl: documentEnUrl,
      documentArUrl: documentArUrl,
    );
  }

  static DateTime? _localDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }
}
