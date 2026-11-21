import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';

class AppErrorBox extends StatelessWidget {
  const AppErrorBox({super.key, required this.message});

  static const _backgroundAlpha = 0.1;

  final String message;

  @override
  Widget build(BuildContext context) {
    final error = context.colorScheme.error;

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: error.withValues(alpha: _backgroundAlpha),
          borderRadius: AppRadius.lgRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.circleAlert, size: AppSizes.iconField, color: error),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(message, style: context.textTheme.bodyMedium?.copyWith(color: error)),
            ),
          ],
        ),
      ),
    );
  }
}
