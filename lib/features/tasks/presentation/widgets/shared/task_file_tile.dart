import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'task_formatters.dart';

class TaskFileTile extends StatelessWidget {
  const TaskFileTile({
    super.key,
    required this.fileName,
    required this.sizeBytes,
    required this.isImage,
    this.onTap,
    this.onRemove,
  });

  final String fileName;
  final int sizeBytes;
  final bool isImage;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final onRemove = this.onRemove;

    return Material(
      color: colors.surface,
      borderRadius: AppRadius.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdRadius,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Icon(
                isImage ? LucideIcons.image : LucideIcons.fileText,
                size: AppSizes.iconMd,
                color: colors.primary,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      TaskFormatters.fileSize(sizeBytes),
                      style: context.textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(LucideIcons.x, size: AppSizes.iconField),
                  tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                )
              else
                Icon(
                  context.isRTL ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
                  size: AppSizes.iconField,
                  color: colors.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
