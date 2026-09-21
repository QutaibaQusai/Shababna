import 'package:flutter_test/flutter_test.dart';
import 'package:shababna/features/auth/data/models/country_phone_code_model.dart';

Map<String, dynamic> _json({Object? length, Object? prefixes}) => {
      'countryName': 'Jordan',
      'countryCode': 'JO',
      'callingCode': '+962',
      'flag': 'JO',
      'nationalNumberLength': length,
      'mobilePrefixes': prefixes,
    };

void main() {
  group('CountryPhoneCodeModel.fromJson', () {
    test('parses a country with full validation rules', () {
      final model = CountryPhoneCodeModel.fromJson(
        _json(length: 9, prefixes: ['77', '78', '79', '75']),
      );

      expect(model.countryCode, 'JO');
      expect(model.callingCode, '+962');
      expect(model.nationalNumberLength, 9);
      expect(model.mobilePrefixes, ['77', '78', '79', '75']);
    });

    test('accepts the length as a string', () {
      final model = CountryPhoneCodeModel.fromJson(_json(length: '9'));

      expect(model.nationalNumberLength, 9);
    });

    test('treats an unparsable length as absent', () {
      final model = CountryPhoneCodeModel.fromJson(_json(length: 'nine'));

      expect(model.nationalNumberLength, isNull);
    });

    test('leaves the rules null when the backend sends null', () {
      final model = CountryPhoneCodeModel.fromJson(_json());

      expect(model.nationalNumberLength, isNull);
      expect(model.mobilePrefixes, isNull);
    });

    test('leaves the rules null when the keys are missing', () {
      final model = CountryPhoneCodeModel.fromJson({
        'countryName': 'Yemen',
        'countryCode': 'YE',
        'callingCode': '+967',
        'flag': 'YE',
      });

      expect(model.nationalNumberLength, isNull);
      expect(model.mobilePrefixes, isNull);
    });
  });
}
