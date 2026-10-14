import 'package:flutter/widgets.dart';

import '../../../../core/di/service_locator.dart';
import '../../domain/services/push_registration_coordinator.dart';
import '../cubit/unread_count/unread_count_cubit.dart';
import '../navigation/push_tap_handler.dart';

class PushNotificationsScope extends StatefulWidget {
  const PushNotificationsScope({super.key, required this.child});

  final Widget child;

  @override
  State<PushNotificationsScope> createState() => _PushNotificationsScopeState();
}

class _PushNotificationsScopeState extends State<PushNotificationsScope> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _onResume);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    sl<PushRegistrationCoordinator>().start();
    sl<PushTapHandler>().start();
  }

  void _onResume() {
    sl<UnreadCountCubit>().refresh();
    sl<PushRegistrationCoordinator>().refresh();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
