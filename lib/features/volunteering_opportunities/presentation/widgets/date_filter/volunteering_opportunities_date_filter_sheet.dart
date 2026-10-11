import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/volunteering_opportunities_date_filter/volunteering_opportunities_date_filter_cubit.dart';

Future<void> showVolunteeringOpportunitiesDateFilterSheet(BuildContext context) async {
  final filter = sl<VolunteeringOpportunitiesDateFilterCubit>();
  final result = await showModalBottomSheet<({DateTime? date})>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    showDragHandle: false,
    builder: (_) => _DateFilterSheet(initialDate: filter.state),
  );
  if (result != null) filter.select(result.date);
}

class _DateFilterSheet extends StatefulWidget {
  const _DateFilterSheet({required this.initialDate});

  final DateTime? initialDate;

  @override
  State<_DateFilterSheet> createState() => _DateFilterSheetState();
}

class _DateFilterSheetState extends State<_DateFilterSheet> {
  static const _yearsRange = 1;
  static const _todayRingWidth = 1.5;
  static const _filterButtonFlex = 2;

  late DateTime? _selected = widget.initialDate;
  late DateTime _focused = widget.initialDate ?? DateTime.now();

  void _onDaySelected(DateTime day, DateTime focused) {
    setState(() {
      _selected = isSameDay(day, _selected) ? null : day;
      _focused = focused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final textTheme = context.textTheme;
    final l10n = context.l10n;
    final now = DateTime.now();
    final isRtl = context.isRTL;
    final dayStyle = textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
    final weekdayStyle = textTheme.labelSmall?.copyWith(
      color: colors.onSurfaceVariant,
      fontWeight: FontWeight.w600,
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        child: Material(
          color: colors.surface,
          borderRadius: AppRadius.xlRadius,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TableCalendar<void>(
                  locale: context.locale.toLanguageTag(),
                  firstDay: DateTime(now.year - _yearsRange, now.month, now.day),
                  lastDay: DateTime(now.year + _yearsRange, now.month, now.day),
                  focusedDay: _focused,
                  selectedDayPredicate: (day) => isSameDay(day, _selected),
                  onDaySelected: _onDaySelected,
                  onPageChanged: (focused) => _focused = focused,
                  availableCalendarFormats: const {CalendarFormat.month: ''},
                  availableGestures: AvailableGestures.horizontalSwipe,
                  rowHeight: AppSizes.calendarRowHeight,
                  daysOfWeekHeight: AppSizes.calendarWeekdaysHeight,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    headerPadding: EdgeInsets.only(bottom: AppSpacing.xs),
                    titleTextStyle:
                        textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) ??
                        const TextStyle(),
                    leftChevronIcon: Icon(
                      isRtl ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
                      size: AppSizes.iconField,
                      color: colors.onSurface,
                    ),
                    rightChevronIcon: Icon(
                      isRtl ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
                      size: AppSizes.iconField,
                      color: colors.onSurface,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: weekdayStyle ?? const TextStyle(),
                    weekendStyle: weekdayStyle ?? const TextStyle(),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    cellMargin: EdgeInsets.all(AppSpacing.xxs),
                    defaultTextStyle: dayStyle ?? const TextStyle(),
                    weekendTextStyle: dayStyle ?? const TextStyle(),
                    selectedDecoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle:
                        dayStyle?.copyWith(color: colors.onPrimary, fontWeight: FontWeight.w700) ??
                        const TextStyle(),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.primary, width: _todayRingWidth),
                    ),
                    todayTextStyle:
                        dayStyle?.copyWith(color: colors.primary, fontWeight: FontWeight.w700) ??
                        const TextStyle(),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    if (widget.initialDate != null || _selected != null) ...[
                      Expanded(
                        child: AppButton.secondary(
                          label: l10n.volunteeringOpportunitiesFilterClear,
                          onPressed: () => Navigator.of(context).pop((date: null)),
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs),
                    ],
                    Expanded(
                      flex: _filterButtonFlex,
                      child: AppButton.primary(
                        label: l10n.actionFilter,
                        onPressed: _selected == null
                            ? null
                            : () => Navigator.of(context).pop((date: _selected)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
