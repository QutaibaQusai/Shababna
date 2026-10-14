import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';
import '../../../../core/notifications/push_message.dart';

class AppNotification extends Equatable {
  const AppNotification({
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

  final String id;
  final NotificationType type;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final String? imageUrl;
  final String? targetId;
  final bool isRead;
  final DateTime createdAt;

  String title(bool isArabic) => _localized(isArabic, en: titleEn, ar: titleAr);

  String body(bool isArabic) => _localized(isArabic, en: bodyEn, ar: bodyAr);

  PushMessage get asPushMessage =>
      PushMessage(notificationId: id, type: type, targetId: targetId);

  AppNotification markedRead() => AppNotification(
    id: id,
    type: type,
    titleEn: titleEn,
    titleAr: titleAr,
    bodyEn: bodyEn,
    bodyAr: bodyAr,
    imageUrl: imageUrl,
    targetId: targetId,
    isRead: true,
    createdAt: createdAt,
  );

  static String _localized(
    bool isArabic, {
    required String en,
    required String ar,
  }) {
    final preferred = isArabic ? ar : en;
    return preferred.isNotEmpty ? preferred : (isArabic ? en : ar);
  }

  @override
  List<Object?> get props => [
    id,
    type,
    titleEn,
    titleAr,
    bodyEn,
    bodyAr,
    imageUrl,
    targetId,
    isRead,
    createdAt,
  ];
}

enum NotificationPreference {
  news,
  event,
  registration,
  task,
  tier,
  certificate,
}

class NotificationPreferences extends Equatable {
  const NotificationPreferences({
    required this.news,
    required this.event,
    required this.registration,
    required this.task,
    required this.tier,
    required this.certificate,
  });

  final bool news;
  final bool event;
  final bool registration;
  final bool task;
  final bool tier;
  final bool certificate;

  bool isEnabled(NotificationPreference preference) => switch (preference) {
    NotificationPreference.news => news,
    NotificationPreference.event => event,
    NotificationPreference.registration => registration,
    NotificationPreference.task => task,
    NotificationPreference.tier => tier,
    NotificationPreference.certificate => certificate,
  };

  NotificationPreferences toggled(NotificationPreference preference) {
    bool flip(NotificationPreference candidate, bool value) =>
        candidate == preference ? !value : value;

    return NotificationPreferences(
      news: flip(NotificationPreference.news, news),
      event: flip(NotificationPreference.event, event),
      registration: flip(NotificationPreference.registration, registration),
      task: flip(NotificationPreference.task, task),
      tier: flip(NotificationPreference.tier, tier),
      certificate: flip(NotificationPreference.certificate, certificate),
    );
  }

  @override
  List<Object?> get props => [
    news,
    event,
    registration,
    task,
    tier,
    certificate,
  ];
}

enum DevicePlatform { android, ios }

abstract interface class NotificationsRepository {
  Future<Either<Failure, PagedResult<AppNotification>>> getNotifications({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, AppNotification>> getNotification(String id);

  Future<Either<Failure, void>> markRead(String id);

  Future<Either<Failure, int>> getUnreadCount();

  Future<Either<Failure, NotificationPreferences>> getPreferences();

  Future<Either<Failure, NotificationPreferences>> updatePreferences(
    NotificationPreferences preferences,
  );

  Future<Either<Failure, void>> registerDevice({
    required String token,
    required String deviceId,
    required DevicePlatform platform,
    required String language,
  });
}
