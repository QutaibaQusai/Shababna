import 'package:firebase_messaging/firebase_messaging.dart';

enum NotificationPermissionStatus { granted, denied, notDetermined }

abstract interface class NotificationPermissionService {
  Future<NotificationPermissionStatus> current();

  Future<NotificationPermissionStatus> request();
}

class FirebaseNotificationPermissionService implements NotificationPermissionService {
  FirebaseNotificationPermissionService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  @override
  Future<NotificationPermissionStatus> current() async {
    final settings = await _messaging.getNotificationSettings();
    return _map(settings.authorizationStatus);
  }

  @override
  Future<NotificationPermissionStatus> request() async {
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true);
    return _map(settings.authorizationStatus);
  }

  NotificationPermissionStatus _map(AuthorizationStatus status) => switch (status) {
        AuthorizationStatus.authorized ||
        AuthorizationStatus.provisional =>
          NotificationPermissionStatus.granted,
        AuthorizationStatus.denied ||
        AuthorizationStatus.deniedPermanently =>
          NotificationPermissionStatus.denied,
        AuthorizationStatus.notDetermined => NotificationPermissionStatus.notDetermined,
      };
}
