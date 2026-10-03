import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'field_card.dart';

class ProfileBirthDateField extends StatelessWidget {
  const ProfileBirthDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hasError = false,
  });

  static const _maxAgeYears = 100;
  static const _defaultAgeYears = 18;

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final bool hasError;

  Future<void> _open(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDate = DateTime(today.year - _maxAgeYears, today.month, today.day);
    final initial = value ?? DateTime(today.year - _defaultAgeYears, today.month, today.day);

    final selected = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (_) => _BirthDateSheet(
        title: label,
        initialDate: _clamp(initial, firstDate, today),
        firstDate: firstDate,
        lastDate: today,
      ),
    );
    if (selected != null) onChanged(selected);
  }

  DateTime _clamp(DateTime date, DateTime min, DateTime max) {
    if (date.isBefore(min)) return min;
    if (date.isAfter(max)) return max;
    return date;
  }

  String? _format(DateTime? date) {
    if (date == null) return null;
    String pad(int value) => value.toString().padLeft(2, '0');
    return '${pad(date.day)}/${pad(date.month)}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return FieldCard(
      label: label,
      icon: LucideIcons.calendar,
      value: _format(value),
      onTap: () => _open(context),
      hasError: hasError,
    );
  }
}

class _BirthDateSheet extends StatefulWidget {
  const _BirthDateSheet({
    required this.title,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final String title;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_BirthDateSheet> createState() => _BirthDateSheetState();
}

class _BirthDateSheetState extends State<_BirthDateSheet> {
  static const _pickerHeight = 216.0;

  late DateTime _selected = widget.initialDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSpacing.screenMargin,
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(_selected),
                  child: Text(context.l10n.doneButton),
                ),
              ],
            ),
            SizedBox(
              height: _pickerHeight,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: Theme.of(context).brightness,
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: widget.initialDate,
                  minimumDate: widget.firstDate,
                  maximumDate: widget.lastDate,
                  onDateTimeChanged: (date) => _selected = date,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
