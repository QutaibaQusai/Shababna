class ContactInfoModel {
  const ContactInfoModel({
    required this.email,
    required this.complaintsEmail,
    required this.phoneNumber,
    required this.complaintsPhoneNumber,
    required this.address,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      email: json['email'] as String,
      complaintsEmail: json['complaintsEmail'] as String,
      phoneNumber: json['phoneNumber'] as String,
      complaintsPhoneNumber: json['complaintsPhoneNumber'] as String,
      address: json['address'] as String,
    );
  }

  final String email;
  final String complaintsEmail;
  final String phoneNumber;
  final String complaintsPhoneNumber;
  final String address;
}
