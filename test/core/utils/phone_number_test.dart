import 'package:flutter_test/flutter_test.dart';
import 'package:shababna/core/utils/phone_number.dart';

void main() {
  group('toNationalDigits', () {
    test('strips a single leading zero', () {
      expect(PhoneNumber.toNationalDigits('0791234567'), '791234567');
    });

    test('leaves numbers without a leading zero untouched', () {
      expect(PhoneNumber.toNationalDigits('791234567'), '791234567');
    });

    test('trims surrounding whitespace before stripping', () {
      expect(PhoneNumber.toNationalDigits('  0791234567 '), '791234567');
    });

    test('strips only one leading zero', () {
      expect(PhoneNumber.toNationalDigits('00791234567'), '0791234567');
    });
  });

  group('toE164', () {
    test('joins the calling code and national digits', () {
      expect(
        PhoneNumber.toE164(callingCode: '+962', input: '0791234567'),
        '+962791234567',
      );
    });

    test('produces the same result with or without the leading zero', () {
      expect(
        PhoneNumber.toE164(callingCode: '+962', input: '791234567'),
        PhoneNumber.toE164(callingCode: '+962', input: '0791234567'),
      );
    });
  });
}
