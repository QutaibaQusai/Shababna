import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../extensions/context_extensions.dart';
import 'app_lock_cubit.dart';
import 'app_lock_screen.dart';
import 'app_lock_state.dart';

class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key, required this.onSignOut, required this.child});

  final Future<void> Function() onSignOut;
  final Widget child;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  late final AppLockCubit _cubit = context.read<AppLockCubit>();
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lifecycle = AppLifecycleListener(
      onHide: () => _cubit.appHidden(),
      onShow: () => _cubit.appShown(),
      onResume: _promptIfPending,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        _promptIfPending();
      }
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async => _cubit.state.isLocked;

  void _promptIfPending() {
    if (!mounted) return;
    _cubit.appResumed(reason: context.l10n.appLockReason);
  }

  void _unlock() => _cubit.unlock(reason: context.l10n.appLockReason);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLockCubit, AppLockState>(
      listenWhen: (previous, current) => !previous.isLocked && current.isLocked,
      listener: (context, state) => FocusManager.instance.primaryFocus?.unfocus(),
      buildWhen: (previous, current) =>
          previous.isLocked != current.isLocked ||
          previous.isAuthenticating != current.isAuthenticating ||
          previous.unlockResult != current.unlockResult,
      builder: (context, state) => Stack(
        fit: StackFit.expand,
        children: [
          Offstage(offstage: state.isLocked, child: widget.child),
          if (state.isLocked)
            AppLockScreen(
              isAuthenticating: state.isAuthenticating,
              result: state.unlockResult,
              onUnlock: _unlock,
              onSignOut: widget.onSignOut,
            ),
        ],
      ),
    );
  }
}
