import 'package:go_router/go_router.dart';

import '../../../../core/notifications/push_message.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/session/auth_session_cubit.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../cubit/unread_count/unread_count_cubit.dart';

class NotificationNavigator {
  NotificationNavigator(
    this._router,
    this._repository,
    this._unreadCount,
    this._session,
  );

  final GoRouter _router;
  final NotificationsRepository _repository;
  final UnreadCountCubit _unreadCount;
  final AuthSessionCubit _session;

  void open(PushMessage message, {bool wasUnread = true}) {
    final isMember = _session.state.isAuthenticated;
    final notificationId = message.notificationId;
    final location = isMember
        ? _memberLocation(message)
        : _guestLocation(message);
    final opensDetails =
        notificationId != null &&
        location == AppRoutes.notificationDetailsPath(notificationId);
    if (isMember && notificationId != null && !opensDetails) {
      _markRead(notificationId, wasUnread: wasUnread);
    }

    if (location == AppRoutes.home) {
      _router.go(location);
    } else {
      _router.push(location);
    }
  }

  String _memberLocation(PushMessage message) {
    final targetId = message.targetId;
    final notificationId = message.notificationId;

    return switch (message.type) {
      NotificationType.news when targetId != null => AppRoutes.newsDetailsPath(
        targetId,
      ),
      NotificationType.event || NotificationType.registration
          when targetId != null =>
        AppRoutes.volunteeringOpportunityDetailsPath(targetId),
      NotificationType.task when targetId != null => AppRoutes.taskDetailsPath(
        targetId,
      ),
      NotificationType.certificate when targetId != null =>
        AppRoutes.certificateDetailsPath(targetId),
      NotificationType.tier => AppRoutes.editProfile,
      NotificationType.general when notificationId != null =>
        AppRoutes.notificationDetailsPath(notificationId),
      _ => AppRoutes.notifications,
    };
  }

  String _guestLocation(PushMessage message) {
    final targetId = message.targetId;

    return switch (message.type) {
      NotificationType.news when targetId != null => AppRoutes.newsDetailsPath(
        targetId,
      ),
      NotificationType.event when targetId != null =>
        AppRoutes.volunteeringOpportunityDetailsPath(targetId),
      _ => AppRoutes.home,
    };
  }

  Future<void> _markRead(String id, {required bool wasUnread}) async {
    if (wasUnread) _unreadCount.decrement();
    await _repository.markRead(id);
    await _unreadCount.refresh();
  }
}
