import 'event_json_parsing.dart';

class EventTypeModel {
  const EventTypeModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.order,
    required this.isActive,
    required this.eventsCount,
  });

  factory EventTypeModel.fromJson(Map<String, dynamic> json) {
    return EventTypeModel(
      id: json['id'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      order: parseEventInt(json['order']),
      isActive: json['isActive'] as bool? ?? true,
      eventsCount: parseEventInt(json['eventsCount']),
    );
  }

  final String id;
  final String nameEn;
  final String nameAr;
  final int order;
  final bool isActive;
  final int eventsCount;
}
