import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/security/app_lock/app_lock_cubit.dart';
import '../../../../../core/security/app_lock/app_lock_state.dart';
import '../../../../../core/security/device_authenticator.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../profile/profile_toggle_tile.dart';

class AppLockTile extends StatefulWidget {
  const AppLockTile({super.key});

  @override
  State<AppLockTile> createState() => _AppLockTileState();
}

class _AppLockTileState extends State<AppLockTile> {
  @override
  void initState() {
    super.initState();
    context.read<AppLockCubit>().refreshAvailability();
  }

  Future<void> _toggle(bool value) async {
    final l10n = context.l10n;
    final result = await context.read<AppLockCubit>().setEnabled(value, reason: l10n.appLockReason);
    if (!mounted) return;
    switch (result) {
      case DeviceAuthResult.unavailable:
        AppToast.warning(context, l10n.appLockUnavailable);
      case DeviceAuthResult.failed:
        AppToast.error(context, l10n.appLockFailed);
      case DeviceAuthResult.success || DeviceAuthResult.cancelled:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLockCubit, AppLockState>(
      buildWhen: (previous, current) =>
          previous.isEnabled != current.isEnabled || previous.canToggle != current.canToggle,
      builder: (context, state) {
        if (!state.canToggle) return const SizedBox.shrink();
        return ProfileToggleTile(
          icon: LucideIcons.fingerprint,
          title: context.l10n.appLockTitle,
          subtitle: context.l10n.appLockSubtitle,
          value: state.isEnabled,
          onChanged: _toggle,
        );
      },
    );
  }
}
