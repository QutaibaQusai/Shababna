import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shababna/core/validators/app_validators.dart';

void main() {
  group('required', () {
    final validate = AppValidators.required('required');

    test('rejects null, empty and whitespace-only values', () {
      expect(validate(null), 'required');
      expect(validate(''), 'required');
      expect(validate('   '), 'required');
    });

    test('accepts a non-empty value', () {
      expect(validate('a'), isNull);
    });
  });

  group('email', () {
    final validate = AppValidators.email('invalid');

    test('accepts a well-formed address', () {
      expect(validate('user@example.com'), isNull);
    });

    test('rejects malformed addresses', () {
      expect(validate(null), 'invalid');
      expect(validate('user'), 'invalid');
      expect(validate('user@'), 'invalid');
      expect(validate('user@example'), 'invalid');
      expect(validate('us er@example.com'), 'invalid');
    });
  });

  group('exactLength', () {
    final validate = AppValidators.exactLength(6, 'invalid code');

    test('accepts a value of exactly the required length', () {
      expect(validate('482913'), isNull);
    });

    test('rejects shorter, longer, empty and null values', () {
      expect(validate('48291'), 'invalid code');
      expect(validate('4829130'), 'invalid code');
      expect(validate(''), 'invalid code');
      expect(validate(null), 'invalid code');
    });
  });

  group('match', () {
    test('compares against the current value of the other field', () {
      var other = 'secret';
      final validate = AppValidators.match(() => other, 'mismatch');

      expect(validate('secret'), isNull);
      expect(validate('other'), 'mismatch');

      other = 'changed';
      expect(validate('secret'), 'mismatch');
    });
  });

  group('combine', () {
    test('returns the first failing validator message', () {
      final validate = AppValidators.combine([
        AppValidators.required('required'),
        AppValidators.email('invalid'),
      ]);

      expect(validate(''), 'required');
      expect(validate('nope'), 'invalid');
      expect(validate('user@example.com'), isNull);
    });
  });

  group('nationalNumber', () {
    String lengthMessage(int length) => 'length:$length';
    String prefixMessage(List<String> prefixes) => 'prefix:${prefixes.join('/')}';

    FormFieldValidator<String> build({int? length, List<String>? prefixes}) {
      return AppValidators.nationalNumber(
        invalidMessage: 'invalid',
        lengthMessage: lengthMessage,
        prefixMessage: prefixMessage,
        length: length,
        prefixes: prefixes,
      );
    }

    group('with country rules (Jordan)', () {
      final validate = build(length: 9, prefixes: ['77', '78', '79', '75']);

      test('accepts a valid number', () {
        expect(validate('791234567'), isNull);
        expect(validate('771234567'), isNull);
        expect(validate('751234567'), isNull);
      });

      test('ignores a single leading zero', () {
        expect(validate('0791234567'), isNull);
      });

      test('rejects a wrong length', () {
        expect(validate('79123456'), 'length:9');
        expect(validate('7912345678'), 'length:9');
      });

      test('rejects a number that does not start with an allowed prefix', () {
        expect(validate('651234567'), 'prefix:77/78/79/75');
      });

      test('reports length before prefix', () {
        expect(validate('65123'), 'length:9');
      });

      test('rejects non-digit input', () {
        expect(validate('79123456a'), 'invalid');
        expect(validate('79 1234567'), 'invalid');
        expect(validate(''), 'invalid');
        expect(validate(null), 'invalid');
      });
    });

    group('with only a length rule', () {
      final validate = build(length: 8);

      test('checks the length and ignores prefixes', () {
        expect(validate('12345678'), isNull);
        expect(validate('1234567'), 'length:8');
      });
    });

    group('with only a prefix rule', () {
      final validate = build(prefixes: ['5']);

      test('checks the prefix and ignores the length', () {
        expect(validate('512345'), isNull);
        expect(validate('612345'), 'prefix:5');
      });
    });

    group('without country rules', () {
      final validate = build();

      test('falls back to a generic 6 to 12 digit check', () {
        expect(validate('123456'), isNull);
        expect(validate('123456789012'), isNull);
        expect(validate('12345'), 'invalid');
        expect(validate('1234567890123'), 'invalid');
      });

      test('treats empty prefixes as no rules', () {
        final withEmpty = build(prefixes: const []);
        expect(withEmpty('123456'), isNull);
        expect(withEmpty('12345'), 'invalid');
      });
    });
  });
}
