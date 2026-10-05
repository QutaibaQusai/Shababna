import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../shared/home_formatters.dart';

class HomeDateStrip extends StatelessWidget {
  const HomeDateStrip({
    super.key,
    required this.today,
    required this.selected,
    required this.onSelected,
  });

  static const dayCount = 14;

  final DateTime today;
  final DateTime selected;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.homeDateCellHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
        itemCount: dayCount,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final day = DateTime(today.year, today.month, today.day + index);
          return _DayCell(
            day: day,
            isToday: index == 0,
            isSelected: DateUtils.isSameDay(day, selected),
            onTap: () => onSelected(day),
          );
        },
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  static const _duration = Duration(milliseconds: 200);

  final DateTime day;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final foreground = isSelected ? colors.onPrimary : colors.onSurface;
    final muted = isSelected ? colors.onPrimary : colors.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdRadius,
        child: AnimatedContainer(
          duration: _duration,
          width: AppSizes.homeDateCellWidth,
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.surface,
            borderRadius: AppRadius.mdRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isToday ? context.l10n.homeToday : HomeFormatters.weekday(context, day),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.xxs),
              Text(
                HomeFormatters.dayOfMonth(context, day),
                style: context.textTheme.titleMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
