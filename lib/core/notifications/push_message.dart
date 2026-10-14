import 'package:equatable/equatable.dart';

enum NotificationType {
  news,
  event,
  general,
  registration,
  task,
  tier,
  certificate,
  unknown;

  static NotificationType fromApi(String? value) =>
      switch (value?.trim().toLowerCase()) {
        'news' => news,
        'event' => event,
        'general' => general,
        'registration' => registration,
        'task' => task,
        'tier' => tier,
        'certificate' => certificate,
        _ => unknown,
      };
}

class PushMessage extends Equatable {
  const PushMessage({
    required this.notificationId,
    required this.type,
    this.targetId,
  });

  factory PushMessage.fromData(Map<String, dynamic> data) {
    String? text(String key) {
      final value = data[key];
      if (value is! String) return null;
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    return PushMessage(
      notificationId: text('notificationId'),
      type: NotificationType.fromApi(text('type')),
      targetId: text('targetId'),
    );
  }

  static const unknown = PushMessage(
    notificationId: null,
    type: NotificationType.unknown,
  );

  final String? notificationId;
  final NotificationType type;
  final String? targetId;

  bool get hasInboxItem => notificationId != null;

  @override
  List<Object?> get props => [notificationId, type, targetId];
}
