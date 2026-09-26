import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class ProfileSheetAction<T> {
  const ProfileSheetAction({
    required this.value,
    required this.icon,
    required this.label,
    this.isDestructive = false,
  });

  final T value;
  final IconData icon;
  final String label;
  final bool isDestructive;
}

abstract final class ProfileActionSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    required List<ProfileSheetAction<T>> actions,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _ProfileActionSheetView<T>(
        title: title,
        subtitle: subtitle,
        actions: actions,
      ),
    );
  }
}

class _ProfileActionSheetView<T> extends StatelessWidget {
  const _ProfileActionSheetView({
    required this.title,
    required this.subtitle,
    required this.actions,
  });

  final String title;
  final String? subtitle;
  final List<ProfileSheetAction<T>> actions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSpacing.screenMargin,
          AppSpacing.xs,
          AppSpacing.screenMargin,
          AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (subtitle != null) ...[
              SizedBox(height: AppSpacing.xxs),
              Text(
                subtitle!,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            SizedBox(height: AppSpacing.sm),
            for (final action in actions) ...[
              _ActionTile(
                action: action,
                onTap: () => Navigator.of(context).pop(action.value),
              ),
              SizedBox(height: AppSpacing.xs),
            ],
            SizedBox(
              height: AppSizes.buttonHeight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.l10n.cancelButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile<T> extends StatelessWidget {
  const _ActionTile({required this.action, required this.onTap});

  final ProfileSheetAction<T> action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = action.isDestructive ? context.colorScheme.error : context.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdRadius,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: context.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.iconButtonSize,
              height: AppSizes.iconButtonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.08),
              ),
              child: Icon(action.icon, size: AppSizes.iconField, color: color),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                action.label,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
