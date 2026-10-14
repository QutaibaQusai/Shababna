import 'package:equatable/equatable.dart';

import '../../../../../core/notifications/notification_permission_service.dart';
import '../../../domain/repositories/notifications_repository.dart';

enum NotificationSettingsStatus { loading, ready, failure }

final class NotificationSettingsError extends Equatable {
  const NotificationSettingsError(this.message);

  final String? message;

  @override
  List<Object?> get props => [message, identityHashCode(this)];
}

class NotificationSettingsState extends Equatable {
  const NotificationSettingsState({
    this.status = NotificationSettingsStatus.loading,
    this.preferences,
    this.permission = NotificationPermissionStatus.notDetermined,
    this.saveError,
    this.errorMessage,
  });

  final NotificationSettingsStatus status;
  final NotificationPreferences? preferences;
  final NotificationPermissionStatus permission;
  final NotificationSettingsError? saveError;
  final String? errorMessage;

  bool get isPermissionGranted =>
      permission == NotificationPermissionStatus.granted;

  bool get isPermissionBlocked =>
      permission == NotificationPermissionStatus.denied;

  NotificationSettingsState copyWith({
    NotificationSettingsStatus? status,
    NotificationPreferences? preferences,
    NotificationPermissionStatus? permission,
    NotificationSettingsError? saveError,
    String? errorMessage,
  }) {
    return NotificationSettingsState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      permission: permission ?? this.permission,
      saveError: saveError ?? this.saveError,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    preferences,
    permission,
    saveError,
    errorMessage,
  ];
}
