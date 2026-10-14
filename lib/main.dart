import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'core/logging/app_logger.dart';
import 'core/notifications/firebase_background_handler.dart';
import 'core/notifications/push_notification_service.dart';
import 'core/services/system_ui_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await SystemUiService.lockPortrait();
  await SystemUiService.hideAndroidNavigationBar();
  await setupServiceLocator();
  await sl<PushNotificationService>().initialize();
  sl<AppLogger>().info('App started', tag: 'main');
  runApp(const ShababnaApp());
}
