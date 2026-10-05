import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class HomeTasksNudge extends StatelessWidget {
  const HomeTasksNudge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: InkWell(
        onTap: () => context.push(AppRoutes.tasks),
        borderRadius: AppRadius.mdRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
          child: Row(
            children: [
              Icon(LucideIcons.listTodo, size: AppSizes.iconMd, color: colors.primary),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  context.l10n.homeTasksNudge(count),
                  style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
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
