import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../../core/notifications/push_message.dart';
import '../../../../core/notifications/push_notification_service.dart';
import 'notification_navigator.dart';

class PushTapHandler {
  PushTapHandler(this._push, this._navigator);

  final PushNotificationService _push;
  final NotificationNavigator _navigator;
  StreamSubscription<PushMessage>? _subscription;

  Future<void> start() async {
    if (_subscription != null) return;
    _subscription = _push.taps.listen(_open);

    final initial = await _push.takeInitialTap();
    if (initial != null) await _open(initial);
  }

  Future<void> _open(PushMessage message) async {
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;
    _navigator.open(message);
  }
}
