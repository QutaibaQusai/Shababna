class ContactFormRequestModel {
  const ContactFormRequestModel({
    required this.fullName,
    required this.email,
    required this.subject,
    required this.body,
  });

  final String fullName;
  final String email;
  final String subject;
  final String body;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'subject': subject,
        'body': body,
      };
}
