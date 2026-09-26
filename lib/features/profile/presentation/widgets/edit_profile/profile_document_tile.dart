import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class ProfileDocumentTile extends StatelessWidget {
  const ProfileDocumentTile({
    super.key,
    required this.label,
    required this.status,
    required this.isUploaded,
    required this.onTap,
    this.hint,
    this.isBusy = false,
  });

  final String label;
  final String status;
  final String? hint;
  final bool isUploaded;
  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = isUploaded ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: isBusy ? null : onTap,
      borderRadius: AppRadius.mdRadius,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          borderRadius: AppRadius.mdRadius,
          border: Border.all(
            color: isUploaded
                ? context.colorScheme.primary.withValues(alpha: 0.4)
                : context.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Row(
                    children: [
                      Icon(
                        isUploaded ? LucideIcons.circleCheck : LucideIcons.circleDashed,
                        size: AppSizes.iconSm,
                        color: accent,
                      ),
                      SizedBox(width: AppSpacing.xxs),
                      Flexible(
                        child: Text(
                          isBusy ? context.l10n.uploadingLabel : status,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall?.copyWith(color: accent),
                        ),
                      ),
                    ],
                  ),
                  if (hint != null) ...[
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      hint!,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            if (isBusy)
              SizedBox(
                width: AppSizes.iconField,
                height: AppSizes.iconField,
                child: CircularProgressIndicator(strokeWidth: 2, color: context.colorScheme.primary),
              )
            else
              Icon(
                isUploaded ? LucideIcons.ellipsisVertical : LucideIcons.upload,
                size: AppSizes.iconField,
                color: context.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
