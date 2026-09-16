class CountryPhoneCodeModel {
  const CountryPhoneCodeModel({
    required this.countryName,
    required this.countryCode,
    required this.callingCode,
    required this.flag,
  });

  factory CountryPhoneCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryPhoneCodeModel(
      countryName: json['countryName'] as String,
      countryCode: json['countryCode'] as String,
      callingCode: json['callingCode'] as String,
      flag: json['flag'] as String,
    );
  }

  final String countryName;
  final String countryCode;
  final String callingCode;
  final String flag;
}
