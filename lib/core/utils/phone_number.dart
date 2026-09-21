class PhoneNumber {
  PhoneNumber._();

  static String toNationalDigits(String input) {
    final digits = input.trim();
    return digits.startsWith('0') ? digits.substring(1) : digits;
  }

  static String toE164({required String callingCode, required String input}) {
    return '$callingCode${toNationalDigits(input)}';
  }
}
