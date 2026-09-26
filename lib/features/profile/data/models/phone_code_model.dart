class PhoneCodeModel {
  const PhoneCodeModel({
    required this.countryName,
    required this.countryCode,
    required this.callingCode,
    required this.flag,
    this.nationalNumberLength,
    this.mobilePrefixes,
  });

  factory PhoneCodeModel.fromJson(Map<String, dynamic> json) {
    final length = json['nationalNumberLength'];
    return PhoneCodeModel(
      countryName: json['countryName'] as String,
      countryCode: json['countryCode'] as String,
      callingCode: json['callingCode'] as String,
      flag: json['flag'] as String,
      nationalNumberLength: length is int ? length : int.tryParse('${length ?? ''}'),
      mobilePrefixes: (json['mobilePrefixes'] as List?)?.cast<String>(),
    );
  }

  final String countryName;
  final String countryCode;
  final String callingCode;
  final String flag;
  final int? nationalNumberLength;
  final List<String>? mobilePrefixes;
}
