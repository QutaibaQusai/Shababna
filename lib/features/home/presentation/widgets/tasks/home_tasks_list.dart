import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/home_repository.dart';
import '../shared/home_formatters.dart';

class HomeTasksList extends StatelessWidget {
  const HomeTasksList({super.key, required this.tasks});

  static const maxVisible = 3;

  final List<HomeTask> tasks;

  @override
  Widget build(BuildContext context) {
    final visible = tasks.take(maxVisible).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Column(
        children: [
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0) SizedBox(height: AppSpacing.xs),
            _TaskCard(task: visible[i]),
          ],
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task});

  static const _stripeWidth = 6.0;

  final HomeTask task;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final textTheme = context.textTheme;
    final isArabic = context.isArabic;
    final isUrgent = task.needsChanges || task.isOverdue;
    final dueColor = isUrgent ? colors.error : colors.onSurfaceVariant;
    final eventTitle = task.eventTitle(isArabic);

    return Material(
      color: colors.surface,
      borderRadius: AppRadius.mdRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.taskDetailsPath(task.id)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: _stripeWidth,
                child: ColoredBox(color: isUrgent ? colors.error : colors.primary),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name(isArabic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (eventTitle.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xxs),
                        Text(
                          eventTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                      SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Icon(LucideIcons.calendarClock, size: AppSizes.iconSm, color: dueColor),
                          SizedBox(width: AppSpacing.xxs),
                          Flexible(
                            child: Text(
                              task.needsChanges
                                  ? context.l10n.taskStatusRejected
                                  : HomeFormatters.relativeDue(context, task.dueAt),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.labelMedium?.copyWith(color: dueColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(end: AppSpacing.xs),
                child: Icon(
                  context.isRTL ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
                  size: AppSizes.iconField,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
