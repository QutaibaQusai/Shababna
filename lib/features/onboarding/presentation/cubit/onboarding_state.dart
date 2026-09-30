import 'package:equatable/equatable.dart';

import '../../../../core/notifications/notification_permission_service.dart';
import 'onboarding_step.dart';

enum NotificationPromptState { ask, requesting, enabled, declined }

class OnboardingState extends Equatable {
  const OnboardingState({
    this.page = 0,
    this.permission = NotificationPermissionStatus.notDetermined,
    this.isRequestingPermission = false,
    this.hasRequestedPermission = false,
  });

  final int page;
  final NotificationPermissionStatus permission;
  final bool isRequestingPermission;
  final bool hasRequestedPermission;

  OnboardingStep get step => OnboardingStep.values[page];

  NotificationPromptState get notificationPrompt {
    if (permission == NotificationPermissionStatus.granted) return NotificationPromptState.enabled;
    if (isRequestingPermission) return NotificationPromptState.requesting;
    if (hasRequestedPermission) return NotificationPromptState.declined;
    return NotificationPromptState.ask;
  }

  OnboardingState copyWith({
    int? page,
    NotificationPermissionStatus? permission,
    bool? isRequestingPermission,
    bool? hasRequestedPermission,
  }) {
    return OnboardingState(
      page: page ?? this.page,
      permission: permission ?? this.permission,
      isRequestingPermission: isRequestingPermission ?? this.isRequestingPermission,
      hasRequestedPermission: hasRequestedPermission ?? this.hasRequestedPermission,
    );
  }

  @override
  List<Object?> get props => [page, permission, isRequestingPermission, hasRequestedPermission];
}
