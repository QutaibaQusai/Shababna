import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
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
      EventRegistrationStatus.pendingApproval => _StatusPill(
        text: l10n.eventStatusPending,
        action: TextButton(
          style: TextButton.styleFrom(foregroundColor: colors.onPrimary),
          onPressed: () => _confirmWithdraw(context),
          child: Text(l10n.eventWithdraw),
        ),
      ),
      EventRegistrationStatus.approved => _StatusPill(text: l10n.eventStatusApproved),
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
    );
    if (confirmed) await cubit.withdraw();
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text, this.action});

  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final action = this.action;
    final colors = context.colorScheme;

    return Container(
      height: AppSizes.slideToConfirmHeight,
      padding: EdgeInsetsDirectional.only(
        start: AppSpacing.md,
        end: action == null ? AppSpacing.md : AppSpacing.xs,
      ),
      decoration: BoxDecoration(color: colors.primary, borderRadius: AppRadius.mdRadius),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleSmall?.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}
