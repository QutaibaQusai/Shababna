class CountryPhoneCodeModel {
  const CountryPhoneCodeModel({
    required this.countryName,
    required this.countryCode,
    required this.callingCode,
    required this.flag,
    this.nationalNumberLength,
    this.mobilePrefixes,
  });

  factory CountryPhoneCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryPhoneCodeModel(
      countryName: json['countryName'] as String,
      countryCode: json['countryCode'] as String,
      callingCode: json['callingCode'] as String,
      flag: json['flag'] as String,
      nationalNumberLength: _parseLength(json['nationalNumberLength']),
      mobilePrefixes: (json['mobilePrefixes'] as List?)?.cast<String>(),
    );
  }

  final String countryName;
  final String countryCode;
  final String callingCode;
  final String flag;
  final int? nationalNumberLength;
  final List<String>? mobilePrefixes;

  static int? _parseLength(Object? value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
