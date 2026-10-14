import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../logging/app_logger.dart';
import 'push_message.dart';

abstract interface class PushNotificationService {
  Future<void> initialize();

  Stream<PushMessage> get taps;

  Stream<PushMessage> get foregroundMessages;

  Stream<String> get onTokenRefresh;

  Future<PushMessage?> takeInitialTap();

  Future<String?> getToken();
}

class FirebasePushNotificationService implements PushNotificationService {
  FirebasePushNotificationService(
    this._logger, {
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  static const _tag = 'Push';
  static const _channelId = 'shababna_general';
  static const _channelName = 'Shababna';
  static const _androidIcon = 'ic_notification';

  static const _channel = AndroidNotificationChannel(
    _channelId,
    _channelName,
    importance: Importance.high,
  );

  final AppLogger _logger;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final _taps = StreamController<PushMessage>.broadcast();
  final _foregroundMessages = StreamController<PushMessage>.broadcast();
  bool _initialized = false;
  bool _initialTapTaken = false;
  int _localNotificationId = 0;

  @override
  Stream<PushMessage> get taps => _taps.stream;

  @override
  Stream<PushMessage> get foregroundMessages => _foregroundMessages.stream;

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      if (Platform.isAndroid) await _initializeAndroidLocalNotifications();
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) => _taps.add(PushMessage.fromData(message.data)),
      );
    } catch (error) {
      _logger.error('Push initialization failed', tag: _tag, error: error);
    }
  }

  @override
  Future<PushMessage?> takeInitialTap() async {
    if (_initialTapTaken) return null;
    _initialTapTaken = true;

    try {
      final remote = await _messaging.getInitialMessage();
      if (remote != null) return PushMessage.fromData(remote.data);

      if (!Platform.isAndroid) return null;
      final launch = await _localNotifications
          .getNotificationAppLaunchDetails();
      final payload = launch?.notificationResponse?.payload;
      if (launch?.didNotificationLaunchApp != true || payload == null) {
        return null;
      }
      return _decode(payload);
    } catch (error) {
      _logger.error(
        'Reading the launch notification failed',
        tag: _tag,
        error: error,
      );
      return null;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      if (Platform.isIOS && await _messaging.getAPNSToken() == null) {
        return null;
      }
      return await _messaging.getToken();
    } catch (error) {
      _logger.warning('Push token unavailable', tag: _tag);
      return null;
    }
  }

  Future<void> _initializeAndroidLocalNotifications() async {
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_androidIcon),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) _taps.add(_decode(payload));
      },
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    _foregroundMessages.add(PushMessage.fromData(message.data));

    final notification = message.notification;
    if (!Platform.isAndroid || notification == null) return;

    try {
      await _localNotifications.show(
        id: _localNotificationId++,
        title: notification.title,
        body: notification.body,
        payload: jsonEncode(message.data),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            importance: Importance.high,
            priority: Priority.high,
            icon: _androidIcon,
          ),
        ),
      );
    } catch (error) {
      _logger.warning('Showing the foreground notification failed', tag: _tag);
    }
  }

  PushMessage _decode(String payload) {
    try {
      final data = jsonDecode(payload);
      if (data is Map<String, dynamic>) return PushMessage.fromData(data);
    } catch (_) {}
    return PushMessage.unknown;
  }
}
