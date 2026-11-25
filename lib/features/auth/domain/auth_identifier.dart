import 'package:equatable/equatable.dart';

import '../../../core/utils/phone_number.dart';
import 'verification_channel.dart';

sealed class AuthIdentifier extends Equatable {
  const AuthIdentifier(this.value);

  final String value;

  VerificationChannel get channel;

  static final _emailInputPattern = RegExp(r'[\p{L}@]', unicode: true);

  static bool isEmailInput(String input) => _emailInputPattern.hasMatch(input);

  static AuthIdentifier? tryParse(String input, {String? callingCode}) {
    return isEmailInput(input)
        ? EmailIdentifier.tryParse(input)
        : PhoneIdentifier.tryParse(input, callingCode: callingCode);
  }

  @override
  List<Object?> get props => [value];
}

final class EmailIdentifier extends AuthIdentifier {
  const EmailIdentifier(super.value);

  static final _pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static EmailIdentifier? tryParse(String input) {
    final text = input.trim();
    return _pattern.hasMatch(text) ? EmailIdentifier(text) : null;
  }

  @override
  VerificationChannel get channel => VerificationChannel.email;
}

final class PhoneIdentifier extends AuthIdentifier {
  const PhoneIdentifier(super.value);

  static const _internationalPrefix = '+';
  static const _minDigits = 8;
  static const _maxDigits = 15;

  static final _separators = RegExp(r'[\s\-().]');
  static final _digitsOnly = RegExp(r'^\d+$');

  static String normalize(String input) => _toAsciiDigits(input.replaceAll(_separators, ''));

  static bool isInternationalInput(String input) =>
      normalize(input).startsWith(_internationalPrefix);

  static PhoneIdentifier? tryParse(String input, {String? callingCode}) {
    final text = normalize(input);
    final e164 = text.startsWith(_internationalPrefix)
        ? text
        : callingCode == null
        ? null
        : PhoneNumber.toE164(callingCode: callingCode, input: text);
    if (e164 == null) return null;

    final digits = e164.substring(_internationalPrefix.length);
    if (!_digitsOnly.hasMatch(digits)) return null;
    if (digits.length < _minDigits || digits.length > _maxDigits) return null;
    return PhoneIdentifier(e164);
  }

  static String _toAsciiDigits(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      buffer.writeCharCode(switch (rune) {
        >= 0x0660 && <= 0x0669 => rune - 0x0660 + 0x30,
        >= 0x06F0 && <= 0x06F9 => rune - 0x06F0 + 0x30,
        _ => rune,
      });
    }
    return buffer.toString();
  }

  @override
  VerificationChannel get channel => VerificationChannel.phone;
}
