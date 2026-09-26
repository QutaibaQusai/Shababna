import '../../domain/repositories/profile_lookups_repository.dart';

class PhoneNumberParts {
  const PhoneNumberParts({required this.code, required this.nationalNumber});

  final PhoneCode code;
  final String nationalNumber;

  static PhoneNumberParts? split(String? phoneNumber, List<PhoneCode> codes) {
    final digits = phoneNumber?.replaceAll(RegExp(r'[\s\-()]'), '') ?? '';
    if (digits.isEmpty) return null;
    final normalized = digits.startsWith('+') ? digits : '+$digits';

    PhoneCode? match;
    for (final code in codes) {
      if (!normalized.startsWith(code.callingCode)) continue;
      if (match == null || code.callingCode.length > match.callingCode.length) match = code;
    }
    if (match == null) return null;

    return PhoneNumberParts(
      code: match,
      nationalNumber: normalized.substring(match.callingCode.length),
    );
  }
}
