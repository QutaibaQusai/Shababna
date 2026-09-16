import 'package:flutter/widgets.dart';

class AppValidators {
  AppValidators._();

  static FormFieldValidator<String> required(String message) {
    return (value) => (value == null || value.trim().isEmpty) ? message : null;
  }

  static FormFieldValidator<String> email(String message) {
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return (value) =>
        (value == null || !pattern.hasMatch(value)) ? message : null;
  }

  static FormFieldValidator<String> minLength(int length, String message) {
    return (value) =>
        (value == null || value.length < length) ? message : null;
  }

  static FormFieldValidator<String> digitsOnly(String message) {
    final pattern = RegExp(r'^\d{6,12}$');
    return (value) => (value == null || !pattern.hasMatch(value)) ? message : null;
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
