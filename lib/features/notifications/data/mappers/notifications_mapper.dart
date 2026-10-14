import '../../../../core/config/app_config.dart';
import '../../../../core/notifications/push_message.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../models/notification_models.dart';

extension NotificationItemModelMapper on NotificationItemModel {
  AppNotification toEntity() {
    final targetId = this.targetId?.trim();
    return AppNotification(
      id: id,
      type: NotificationType.fromApi(type),
      titleEn: titleEn.trim(),
      titleAr: titleAr.trim(),
      bodyEn: bodyEn.trim(),
      bodyAr: bodyAr.trim(),
      imageUrl: _absoluteUrl(imageUrl),
      targetId: targetId == null || targetId.isEmpty ? null : targetId,
      isRead: isRead,
      createdAt: (DateTime.tryParse(createdAt) ?? DateTime.now()).toLocal(),
    );
  }
}

extension NotificationPreferencesModelMapper on NotificationPreferencesModel {
  NotificationPreferences toEntity() => NotificationPreferences(
    news: news,
    event: event,
    registration: registration,
    task: task,
    tier: tier,
    certificate: certificate,
  );
}

extension NotificationPreferencesMapper on NotificationPreferences {
  NotificationPreferencesModel toModel() => NotificationPreferencesModel(
    news: news,
    event: event,
    registration: registration,
    task: task,
    tier: tier,
    certificate: certificate,
  );
}

String? _absoluteUrl(String? path) {
  if (path == null || path.trim().isEmpty) return null;
  return path.startsWith('http') ? path : '${AppConfig.baseUrl}$path';
}
