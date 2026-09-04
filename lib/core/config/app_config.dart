import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  static const String appName = 'Shababna';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;

  // TODO: replace with the real backend base URL once it's provided.
  static const String baseUrl = 'https://TODO-shababna-api.example.com';

  static bool get isProduction => !kDebugMode;
  static bool get isDevelopment => kDebugMode;
}