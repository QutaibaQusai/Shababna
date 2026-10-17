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
import '../../../domain/repositories/volunteering_opportunities_repository.dart';
import '../../cubit/volunteering_opportunity_details/volunteering_opportunity_details_cubit.dart';
import 'slide_to_confirm.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

class VolunteeringOpportunityRegistrationBar extends StatelessWidget {
  const VolunteeringOpportunityRegistrationBar({super.key});

  static const _switchDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<VolunteeringOpportunityDetailsCubit>().state;
    final isAuthenticated = context.watch<AuthSessionCubit>().state.isAuthenticated;
    final volunteeringOpportunity = state.volunteeringOpportunity;
    if (volunteeringOpportunity == null) return const SizedBox.shrink();

    return Material(
      color: context.colorScheme.surface,
      child: AppBottomSafeArea(
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
              key: ValueKey((
                volunteeringOpportunity.registrationStatus,
                isAuthenticated,
                volunteeringOpportunity.hasEnded,
              )),
              child: _content(
                context,
                volunteeringOpportunity,
                isAuthenticated,
                state.isSubmitting,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    VolunteeringOpportunityDetails volunteeringOpportunity,
    bool isAuthenticated,
    bool isSubmitting,
  ) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final cubit = context.read<VolunteeringOpportunityDetailsCubit>();
    final status = volunteeringOpportunity.registrationStatus;
    final canRegister =
        status == VolunteeringOpportunityRegistrationStatus.notRegistered ||
        status == VolunteeringOpportunityRegistrationStatus.withdrawn;

    if (volunteeringOpportunity.hasEnded && (canRegister || !isAuthenticated)) {
      return _StatusPill(text: l10n.volunteeringOpportunityEnded);
    }

    if (!isAuthenticated) {
      return AppButton.primary(
        label: l10n.volunteeringOpportunitySignInToRegister,
        onPressed: () => ensureSignedIn(context),
      );
    }

    return switch (status) {
      VolunteeringOpportunityRegistrationStatus.notRegistered ||
      VolunteeringOpportunityRegistrationStatus.withdrawn => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (volunteeringOpportunity.requiresApproval) ...[
            Text(
              l10n.volunteeringOpportunityRequiresApprovalHint,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
            SizedBox(height: AppSpacing.xs),
          ],
          SlideToConfirm(
            label: status == VolunteeringOpportunityRegistrationStatus.withdrawn
                ? l10n.volunteeringOpportunitySlideToRegisterAgain
                : l10n.volunteeringOpportunitySlideToRegister,
            isLoading: isSubmitting,
            onConfirmed: cubit.register,
          ),
        ],
      ),
      VolunteeringOpportunityRegistrationStatus.pendingApproval => Row(
        children: [
          Expanded(child: _StatusPill(text: l10n.volunteeringOpportunityStatusPending)),
          SizedBox(width: AppSpacing.xs),
          _BarButton(
            label: l10n.volunteeringOpportunityWithdraw,
            color: colors.error,
            onColor: colors.onError,
            onPressed: () => _confirmWithdraw(context),
          ),
        ],
      ),
      VolunteeringOpportunityRegistrationStatus.approved => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.circleCheck, size: AppSizes.iconSm, color: colors.primary),
              SizedBox(width: AppSpacing.xxs),
              Text(
                l10n.volunteeringOpportunityStatusApproved,
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
              label: l10n.tasksVolunteeringOpportunityTitle,
              color: colors.primary,
              onColor: colors.onPrimary,
              icon: context.isRTL ? LucideIcons.arrowLeft : LucideIcons.arrowRight,
              onPressed: () => context.push(
                AppRoutes.volunteeringOpportunityTasksPath(volunteeringOpportunity.id),
              ),
            ),
          ),
        ],
      ),
      VolunteeringOpportunityRegistrationStatus.rejected => _StatusPill(
        text: l10n.volunteeringOpportunityStatusRejected,
      ),
    };
  }

  Future<void> _confirmWithdraw(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<VolunteeringOpportunityDetailsCubit>();
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.volunteeringOpportunityWithdrawConfirmTitle,
      message: l10n.volunteeringOpportunityWithdrawConfirmMessage,
      confirmText: l10n.volunteeringOpportunityWithdraw,
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
