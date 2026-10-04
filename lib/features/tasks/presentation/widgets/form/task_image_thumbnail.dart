import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class TaskImageThumbnail extends StatelessWidget {
  const TaskImageThumbnail({super.key, required this.path, required this.onRemove});

  static const _cacheWidth = 320;
  static const _scrimAlpha = 0.55;

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return ClipRRect(
      borderRadius: AppRadius.mdRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(path),
            fit: BoxFit.cover,
            cacheWidth: _cacheWidth,
            errorBuilder: (_, _, _) => ColoredBox(
              color: colors.surfaceContainerHighest,
              child: Icon(LucideIcons.imageOff, color: colors.onSurfaceVariant),
            ),
          ),
          PositionedDirectional(
            top: AppSpacing.xxs,
            end: AppSpacing.xxs,
            child: Semantics(
              button: true,
              label: MaterialLocalizations.of(context).deleteButtonTooltip,
              child: GestureDetector(
                onTap: onRemove,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: _scrimAlpha),
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: AppSizes.iconMd,
                    child: Icon(LucideIcons.x, size: AppSizes.iconSm, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
