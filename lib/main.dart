import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'core/logging/app_logger.dart';
import 'core/services/system_ui_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemUiService.lockPortrait();
  await SystemUiService.hideAndroidNavigationBar();
  await setupServiceLocator();
  sl<AppLogger>().info('App started', tag: 'main');
  runApp(const ShababnaApp());
}
