import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  static const String appName = 'Shababna';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;

  static const String baseUrl = 'https://rhas.hitechjo.com';

  static const int otpLength = 6;

  static bool get isProduction => !kDebugMode;
  static bool get isDevelopment => kDebugMode;
}