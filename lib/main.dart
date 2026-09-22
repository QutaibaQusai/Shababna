import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'core/logging/app_logger.dart';
import 'core/services/system_ui_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemUiService.hideAndroidNavigationBar();
  await setupServiceLocator();
  sl<AppLogger>().info('App started', tag: 'main');
  runApp(const ShababnaApp());
}
