class VolunteeringOpportunityRegistrationModel {
  const VolunteeringOpportunityRegistrationModel({
    required this.registrationStatus,
    required this.message,
  });

  factory VolunteeringOpportunityRegistrationModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringOpportunityRegistrationModel(
      registrationStatus: json['registrationStatus'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  final String registrationStatus;
  final String message;
}
