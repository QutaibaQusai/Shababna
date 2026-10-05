import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/session/auth_session_cubit.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_dialog.dart';
import '../../../../../core/shared/widgets/guest_gate.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/events_repository.dart';
import '../../cubit/event_details/event_details_cubit.dart';
import 'slide_to_confirm.dart';

class EventRegistrationBar extends StatelessWidget {
  const EventRegistrationBar({super.key});

  static const _switchDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EventDetailsCubit>().state;
    final isAuthenticated = context.watch<AuthSessionCubit>().state.isAuthenticated;
    final event = state.event;
    if (event == null) return const SizedBox.shrink();

    return Material(
      color: context.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.sm,
            AppSpacing.screenMargin,
            AppSpacing.md,
          ),
          child: AnimatedSwitcher(
            duration: _switchDuration,
            child: KeyedSubtree(
              key: ValueKey((event.registrationStatus, isAuthenticated, event.hasEnded)),
              child: _content(context, event, isAuthenticated, state.isSubmitting),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    EventDetails event,
    bool isAuthenticated,
    bool isSubmitting,
  ) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final cubit = context.read<EventDetailsCubit>();
    final status = event.registrationStatus;
    final canRegister =
        status == EventRegistrationStatus.notRegistered ||
        status == EventRegistrationStatus.withdrawn;

    if (event.hasEnded && (canRegister || !isAuthenticated)) {
      return _StatusPill(text: l10n.eventEnded);
    }

    if (!isAuthenticated) {
      return AppButton.primary(
        label: l10n.eventSignInToRegister,
        onPressed: () => ensureSignedIn(context),
      );
    }

    return switch (status) {
      EventRegistrationStatus.notRegistered || EventRegistrationStatus.withdrawn => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (event.requiresApproval) ...[
            Text(
              l10n.eventRequiresApprovalHint,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
            SizedBox(height: AppSpacing.xs),
          ],
          SlideToConfirm(
            label: status == EventRegistrationStatus.withdrawn
                ? l10n.eventSlideToRegisterAgain
                : l10n.eventSlideToRegister,
            isLoading: isSubmitting,
            onConfirmed: cubit.register,
          ),
        ],
      ),
      EventRegistrationStatus.pendingApproval => Row(
        children: [
          Expanded(child: _StatusPill(text: l10n.eventStatusPending)),
          SizedBox(width: AppSpacing.xs),
          _BarButton(
            label: l10n.eventWithdraw,
            color: colors.error,
            onColor: colors.onError,
            onPressed: () => _confirmWithdraw(context),
          ),
        ],
      ),
      EventRegistrationStatus.approved => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.circleCheck, size: AppSizes.iconSm, color: colors.primary),
              SizedBox(width: AppSpacing.xxs),
              Text(
                l10n.eventStatusApproved,
                style: context.textTheme.labelLarge?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          SizedBox(
            width: double.infinity,
            child: _BarButton(
              label: l10n.tasksEventTitle,
              color: colors.primary,
              onColor: colors.onPrimary,
              icon: context.isRTL ? LucideIcons.arrowLeft : LucideIcons.arrowRight,
              onPressed: () => context.push(AppRoutes.eventTasksPath(event.id)),
            ),
          ),
        ],
      ),
      EventRegistrationStatus.rejected => _StatusPill(text: l10n.eventStatusRejected),
    };
  }

  Future<void> _confirmWithdraw(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<EventDetailsCubit>();
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.eventWithdrawConfirmTitle,
      message: l10n.eventWithdrawConfirmMessage,
      confirmText: l10n.eventWithdraw,
      cancelText: l10n.cancelButton,
      isDestructive: true,
    );
    if (confirmed) await cubit.withdraw();
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Container(
      height: AppSizes.slideToConfirmHeight,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.primary, borderRadius: AppRadius.mdRadius),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleSmall?.copyWith(
          color: colors.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.label,
    required this.color,
    required this.onColor,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final Color color;
  final Color onColor;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;

    return Material(
      color: color,
      borderRadius: AppRadius.mdRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: AppSizes.slideToConfirmHeight,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: context.textTheme.titleSmall?.copyWith(
                  color: onColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: AppSpacing.xs),
                Icon(icon, size: AppSizes.iconField, color: onColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
