class EventRegistrationModel {
  const EventRegistrationModel({required this.registrationStatus, required this.message});

  factory EventRegistrationModel.fromJson(Map<String, dynamic> json) {
    return EventRegistrationModel(
      registrationStatus: json['registrationStatus'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  final String registrationStatus;
  final String message;
}
