class EmailRequestModel {
  const EmailRequestModel({required this.email});

  final String email;

  Map<String, dynamic> toJson() => {'email': email};
}
