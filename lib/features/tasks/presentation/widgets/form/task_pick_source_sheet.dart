import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

enum TaskPickSource { camera, gallery, document }

abstract final class TaskPickSourceSheet {
  static Future<TaskPickSource?> show(BuildContext context, {required bool allowDocuments}) {
    final l10n = context.l10n;

    return showModalBottomSheet<TaskPickSource>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _SheetView(
        options: [
          (TaskPickSource.camera, LucideIcons.camera, l10n.taskTakePhoto),
          (TaskPickSource.gallery, LucideIcons.images, l10n.taskChooseFromGallery),
          if (allowDocuments) (TaskPickSource.document, LucideIcons.fileText, l10n.taskAddFile),
        ],
      ),
    );
  }
}

class _SheetView extends StatelessWidget {
  const _SheetView({required this.options});

  final List<(TaskPickSource, IconData, String)> options;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenMargin,
          AppSpacing.xs,
          AppSpacing.screenMargin,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, (source, icon, label)) in options.indexed) ...[
              if (index > 0) SizedBox(height: AppSpacing.xs),
              _OptionTile(icon: icon, label: label, onTap: () => Navigator.of(context).pop(source)),
            ],
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdRadius,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
              child: SizedBox.square(
                dimension: AppSizes.iconButtonSize,
                child: Icon(icon, size: AppSizes.iconField, color: colors.onPrimary),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
