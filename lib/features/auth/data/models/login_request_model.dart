class LoginRequestModel {
  const LoginRequestModel({
    required this.identifier,
    required this.password,
    this.deviceId,
    this.deviceName,
  });

  final String identifier;
  final String password;
  final String? deviceId;
  final String? deviceName;

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'password': password,
    if (deviceId != null) 'deviceId': deviceId,
    if (deviceName != null) 'deviceName': deviceName,
  };
}
