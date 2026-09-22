class CheckRegistrationRequestModel {
  const CheckRegistrationRequestModel({required this.email, required this.phoneNumber});

  final String email;
  final String phoneNumber;

  Map<String, dynamic> toJson() => {'email': email, 'phoneNumber': phoneNumber};
}
