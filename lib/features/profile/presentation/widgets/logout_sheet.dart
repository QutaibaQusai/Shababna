import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/state/form_status.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/cubit/logout/logout_cubit.dart';
import '../../../auth/presentation/cubit/logout/logout_state.dart';

class LogoutSheet extends StatelessWidget {
  const LogoutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == FormStatus.submitting;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenMargin,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppSizes.iconLg * 2,
                  height: AppSizes.iconLg * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.error.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    LucideIcons.power,
                    size: AppSizes.iconLg,
                    color: context.colorScheme.error,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.logoutSheetTitle,
                  style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  context.l10n.logoutSheetConfirmation,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : () => context.read<LogoutCubit>().logout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.error,
                      foregroundColor: context.colorScheme.onError,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
                    ),
                    child: isSubmitting
                        ? SizedBox(
                            width: AppSizes.iconSm,
                            height: AppSizes.iconSm,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.colorScheme.onError,
                            ),
                          )
                        : Text(context.l10n.logoutConfirmButton),
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: TextButton(
                    onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
                    child: Text(context.l10n.cancelButton),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
