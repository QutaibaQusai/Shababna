class NotificationItemModel {
  const NotificationItemModel({
    required this.id,
    required this.type,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.imageUrl,
    required this.targetId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['id'] as String,
      type: json['type'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      bodyEn: json['bodyEn'] as String? ?? '',
      bodyAr: json['bodyAr'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      targetId: json['targetId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  final String id;
  final String type;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final String? imageUrl;
  final String? targetId;
  final bool isRead;
  final String createdAt;
}

class NotificationPreferencesModel {
  const NotificationPreferencesModel({
    required this.news,
    required this.event,
    required this.registration,
    required this.task,
    required this.tier,
    required this.certificate,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    bool flag(String key) => json[key] as bool? ?? true;
    return NotificationPreferencesModel(
      news: flag('news'),
      event: flag('event'),
      registration: flag('registration'),
      task: flag('task'),
      tier: flag('tier'),
      certificate: flag('certificate'),
    );
  }

  final bool news;
  final bool event;
  final bool registration;
  final bool task;
  final bool tier;
  final bool certificate;

  Map<String, dynamic> toJson() => {
    'news': news,
    'event': event,
    'registration': registration,
    'task': task,
    'tier': tier,
    'certificate': certificate,
  };
}
