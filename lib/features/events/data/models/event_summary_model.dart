import 'event_json_parsing.dart';

class EventSummaryModel {
  const EventSummaryModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.eventType,
    required this.from,
    required this.to,
    required this.address,
    required this.gender,
    required this.ageFrom,
    required this.ageTo,
    required this.hours,
    required this.volunteersCount,
    required this.requiresApproval,
    required this.imageUrl,
  });

  factory EventSummaryModel.fromJson(Map<String, dynamic> json) {
    return EventSummaryModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      eventType: EventReferenceModel.fromJson(
        json['eventType'] as Map<String, dynamic>? ?? const {},
      ),
      from: json['from'] as String,
      to: json['to'] as String,
      address: json['address'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      ageFrom: parseEventInt(json['ageFrom']),
      ageTo: parseEventInt(json['ageTo']),
      hours: parseEventInt(json['hours']),
      volunteersCount: parseEventInt(json['volunteersCount']),
      requiresApproval: json['requiresApproval'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final EventReferenceModel eventType;
  final String from;
  final String to;
  final String address;
  final String gender;
  final int ageFrom;
  final int ageTo;
  final int hours;
  final int volunteersCount;
  final bool requiresApproval;
  final String imageUrl;
}
