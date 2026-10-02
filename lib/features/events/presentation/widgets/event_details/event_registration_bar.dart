import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/session/auth_session_cubit.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_dialog.dart';
import '../../../../../core/shared/widgets/guest_gate.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/events_repository.dart';
import '../../cubit/event_details/event_details_cubit.dart';

class EventRegistrationBar extends StatelessWidget {
  const EventRegistrationBar({super.key});

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
            AppSpacing.sm,
          ),
          child: _content(context, event, isAuthenticated, state.isSubmitting),
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
    final cubit = context.read<EventDetailsCubit>();
    final status = event.registrationStatus;
    final canRegister = status == EventRegistrationStatus.notRegistered ||
        status == EventRegistrationStatus.withdrawn;

    if (event.hasEnded && (canRegister || !isAuthenticated)) {
      return _StatusLine(
        icon: LucideIcons.calendarX,
        text: l10n.eventEnded,
        color: context.colorScheme.onSurfaceVariant,
      );
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
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
            ],
            isSubmitting
                ? const _SubmittingButton()
                : AppButton.primary(
                    label: status == EventRegistrationStatus.withdrawn
                        ? l10n.eventRegisterAgain
                        : l10n.eventRegister,
                    onPressed: cubit.register,
                  ),
          ],
        ),
      EventRegistrationStatus.pendingApproval => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusLine(
              icon: LucideIcons.hourglass,
              text: l10n.eventStatusPending,
              color: AppColors.warningColor,
            ),
            SizedBox(height: AppSpacing.sm),
            isSubmitting
                ? const _SubmittingButton()
                : AppButton.secondary(
                    label: l10n.eventWithdraw,
                    onPressed: () => _confirmWithdraw(context),
                  ),
          ],
        ),
      EventRegistrationStatus.approved => _StatusLine(
          icon: LucideIcons.circleCheck,
          text: l10n.eventStatusApproved,
          color: AppColors.successColor,
        ),
      EventRegistrationStatus.rejected => _StatusLine(
          icon: LucideIcons.circleX,
          text: l10n.eventStatusRejected,
          color: context.colorScheme.error,
        ),
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
    );
    if (confirmed) await cubit.withdraw();
  }
}

class _SubmittingButton extends StatelessWidget {
  const _SubmittingButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: SizedBox.square(
        dimension: AppSizes.iconField,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSizes.iconMd, color: color),
          SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              text,
              style: context.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
