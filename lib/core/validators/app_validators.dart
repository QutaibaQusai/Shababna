import 'package:flutter/widgets.dart';

import '../utils/phone_number.dart';

class AppValidators {
  AppValidators._();

  static final _digitsPattern = RegExp(r'^\d+$');
  static final _genericNationalNumberPattern = RegExp(r'^\d{6,12}$');

  static FormFieldValidator<String> required(String message) {
    return (value) => (value == null || value.trim().isEmpty) ? message : null;
  }

  static FormFieldValidator<String> email(String message) {
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return (value) =>
        (value == null || !pattern.hasMatch(value)) ? message : null;
  }

  static FormFieldValidator<String> exactLength(int length, String message) {
    return (value) => (value?.length ?? 0) == length ? null : message;
  }

  static FormFieldValidator<String> nationalNumber({
    required String invalidMessage,
    required String Function(int length) lengthMessage,
    required String Function(List<String> prefixes) prefixMessage,
    int? length,
    List<String>? prefixes,
  }) {
    final requiredPrefixes = prefixes ?? const <String>[];
    final hasRules = length != null || requiredPrefixes.isNotEmpty;

    return (value) {
      final digits = PhoneNumber.toNationalDigits(value ?? '');
      if (!_digitsPattern.hasMatch(digits)) return invalidMessage;

      if (!hasRules) {
        return _genericNationalNumberPattern.hasMatch(digits) ? null : invalidMessage;
      }
      if (length != null && digits.length != length) return lengthMessage(length);
      if (requiredPrefixes.isNotEmpty && !requiredPrefixes.any(digits.startsWith)) {
        return prefixMessage(requiredPrefixes);
      }
      return null;
    };
  }

  static FormFieldValidator<String> match(
    String Function() getOtherValue,
    String message,
  ) {
    return (value) => (value != getOtherValue()) ? message : null;
  }

  static FormFieldValidator<String> combine(
    List<FormFieldValidator<String>> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
