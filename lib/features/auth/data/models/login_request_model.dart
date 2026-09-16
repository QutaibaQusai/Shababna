class LoginRequestModel {
  const LoginRequestModel({
    required this.email,
    required this.password,
    this.deviceId,
    this.deviceName,
  });

  final String email;
  final String password;
  final String? deviceId;
  final String? deviceName;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        if (deviceId != null) 'deviceId': deviceId,
        if (deviceName != null) 'deviceName': deviceName,
      };
}
