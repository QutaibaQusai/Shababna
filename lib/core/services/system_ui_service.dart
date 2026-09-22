import 'dart:io';

import 'package:flutter/services.dart';

class SystemUiService {
  SystemUiService._();

  static const _channel = MethodChannel('com.hitech.shababna/systemui');

  static Future<void> hideAndroidNavigationBar() async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('hideBottomSticky');
    } catch (_) {}
  }
}
