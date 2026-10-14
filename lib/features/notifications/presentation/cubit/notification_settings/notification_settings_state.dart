import 'package:equatable/equatable.dart';

import '../../../../../core/notifications/notification_permission_service.dart';
import '../../../domain/repositories/notifications_repository.dart';

enum NotificationSettingsStatus { loading, ready, failure }

sealed class NotificationSettingsFeedback extends Equatable {
  const NotificationSettingsFeedback();
}

final class NotificationSettingsError extends NotificationSettingsFeedback {
  const NotificationSettingsError(this.message);

  final String? message;

  @override
  List<Object?> get props => [message, identityHashCode(this)];
}

final class NotificationTestSent extends NotificationSettingsFeedback {
  const NotificationTestSent();

  @override
  List<Object?> get props => [identityHashCode(this)];
}

class NotificationSettingsState extends Equatable {
  const NotificationSettingsState({
    this.status = NotificationSettingsStatus.loading,
    this.preferences,
    this.permission = NotificationPermissionStatus.notDetermined,
    this.isSendingTest = false,
    this.feedback,
    this.errorMessage,
  });

  final NotificationSettingsStatus status;
  final NotificationPreferences? preferences;
  final NotificationPermissionStatus permission;
  final bool isSendingTest;
  final NotificationSettingsFeedback? feedback;
  final String? errorMessage;

  bool get isPermissionGranted =>
      permission == NotificationPermissionStatus.granted;

  bool get isPermissionBlocked =>
      permission == NotificationPermissionStatus.denied;

  NotificationSettingsState copyWith({
    NotificationSettingsStatus? status,
    NotificationPreferences? preferences,
    NotificationPermissionStatus? permission,
    bool? isSendingTest,
    NotificationSettingsFeedback? feedback,
    String? errorMessage,
  }) {
    return NotificationSettingsState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      permission: permission ?? this.permission,
      isSendingTest: isSendingTest ?? this.isSendingTest,
      feedback: feedback ?? this.feedback,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    preferences,
    permission,
    isSendingTest,
    feedback,
    errorMessage,
  ];
}
