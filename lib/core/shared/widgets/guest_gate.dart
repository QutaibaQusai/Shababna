import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:go_router/go_router.dart';

import '../../extensions/context_extensions.dart';
import '../../routes/app_routes.dart';
import '../../session/auth_session_cubit.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';
import 'app_button.dart';

Future<bool> ensureSignedIn(BuildContext context) async {
  if (context.read<AuthSessionCubit>().state.isAuthenticated) return true;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSpacing.screenMargin,
          AppSpacing.md,
          AppSpacing.screenMargin,
          AppSpacing.md,
        ),
        child: GuestGateContent(
          onSignIn: () {
            Navigator.of(sheetContext).pop();
            context.push(AppRoutes.login);
          },
          onCreateAccount: () {
            Navigator.of(sheetContext).pop();
            context.push(AppRoutes.register);
          },
        ),
      ),
    ),
  );
  return false;
}

class GuestGate extends StatelessWidget {
  const GuestGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthSessionCubit>().state;
    if (!status.isGuest) return child;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenMargin),
          child: GuestGateContent(
            onSignIn: () => context.push(AppRoutes.login),
            onCreateAccount: () => context.push(AppRoutes.register),
          ),
        ),
      ),
    );
  }
}

class GuestGateContent extends StatelessWidget {
  const GuestGateContent({
    super.key,
    required this.onSignIn,
    required this.onCreateAccount,
    this.title,
    this.message,
  });

  static const _entranceDuration = Duration(milliseconds: 320);
  static const _entranceOffset = 16.0;

  final VoidCallback onSignIn;
  final VoidCallback onCreateAccount;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: _entranceDuration,
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * _entranceOffset),
          child: child,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Undraw(
            illustration: UndrawIllustration.secureLogin,
            color: context.colorScheme.primary,
            height: AppSizes.illustrationSizeCompact,
            placeholder: SizedBox(height: AppSizes.illustrationSizeCompact),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            title ?? context.l10n.guestGateTitle,
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            message ?? context.l10n.guestGateMessage,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          AppButton.primary(label: context.l10n.loginButton, onPressed: onSignIn),
          SizedBox(height: AppSpacing.xs),
          AppButton.text(label: context.l10n.createAccountButton, onPressed: onCreateAccount),
        ],
      ),
    );
  }
}
