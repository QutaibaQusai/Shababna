import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/task_grouping.dart';

class TaskTabs extends StatelessWidget {
  const TaskTabs({
    super.key,
    required this.selected,
    required this.countOf,
    required this.onSelected,
  });

  final TaskTab selected;
  final int Function(TaskTab tab) countOf;
  final ValueChanged<TaskTab> onSelected;

  static String label(AppLocalizations l10n, TaskTab tab) => switch (tab) {
    TaskTab.all => l10n.tasksTabAll,
    TaskTab.todo => l10n.tasksTabTodo,
    TaskTab.inReview => l10n.tasksTabInReview,
    TaskTab.completed => l10n.tasksTabCompleted,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final tab in TaskTab.values) ...[
            if (tab != TaskTab.values.first) SizedBox(width: AppSpacing.xs),
            _TabItem(
              label: label(context.l10n, tab),
              count: countOf(tab),
              isSelected: tab == selected,
              onTap: () => onSelected(tab),
            ),
          ],
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  static const _duration = Duration(milliseconds: 200);

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final color = isSelected ? colors.primary : colors.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smRadius,
        child: Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.xxs, AppSpacing.xs, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: _duration,
                    style: (context.textTheme.labelLarge ?? const TextStyle()).copyWith(
                      color: color,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    child: Text(label),
                  ),
                  SizedBox(width: AppSpacing.xxs),
                  Text(
                    '$count',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xxs),
              AnimatedContainer(
                duration: _duration,
                width: AppSizes.tabIndicatorDotSize,
                height: AppSizes.tabIndicatorDotSize,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
