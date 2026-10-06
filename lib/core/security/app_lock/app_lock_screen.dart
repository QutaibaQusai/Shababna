import 'package:flutter/material.dart';

import '../../config/app_assets.dart';
import '../../extensions/context_extensions.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_illustration.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';
import '../device_authenticator.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({
    super.key,
    required this.isAuthenticating,
    required this.result,
    required this.onUnlock,
    required this.onSignOut,
  });

  final bool isAuthenticating;
  final DeviceAuthResult? result;
  final VoidCallback onUnlock;
  final Future<void> Function() onSignOut;

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    try {
      await widget.onSignOut();
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final isUnavailable = widget.result == DeviceAuthResult.unavailable;
    final isBusy = widget.isAuthenticating || _isSigningOut;
    final error = switch (widget.result) {
      DeviceAuthResult.failed => l10n.appLockFailed,
      DeviceAuthResult.unavailable => l10n.appLockUnavailableLocked,
      _ => null,
    };

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              AppIllustration(
                asset: AppAssets.illustrationAppLock,
                height: AppSizes.illustrationSize,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                l10n.appLockLockedTitle,
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                l10n.appLockLockedMessage,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
              if (error != null) ...[
                SizedBox(height: AppSpacing.sm),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(color: colors.error),
                ),
              ],
              const Spacer(),
              if (!isUnavailable) ...[
                AppButton.primary(
                  label: l10n.appLockUnlock,
                  onPressed: isBusy ? null : widget.onUnlock,
                ),
                SizedBox(height: AppSpacing.xs),
              ],
              AppButton.text(label: l10n.profileMenuLogout, onPressed: isBusy ? null : _signOut),
            ],
          ),
        ),
      ),
    );
  }
}
