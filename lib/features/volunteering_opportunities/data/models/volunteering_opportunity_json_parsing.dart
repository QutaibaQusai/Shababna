int parseVolunteeringOpportunityInt(Object? value) => switch (value) {
      int() => value,
      num() => value.toInt(),
      String() => int.tryParse(value) ?? 0,
      _ => 0,
    };

List<T> parseVolunteeringOpportunityList<T>(
  Object? value,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (value is! List) return const [];
  return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
}

class VolunteeringOpportunityReferenceModel {
  const VolunteeringOpportunityReferenceModel({required this.id, required this.name});

  factory VolunteeringOpportunityReferenceModel.fromJson(Map<String, dynamic> json) {
    return VolunteeringOpportunityReferenceModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  final String id;
  final String name;
}
