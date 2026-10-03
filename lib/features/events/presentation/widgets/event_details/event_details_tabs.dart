import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/events_repository.dart';
import 'event_eligibility_section.dart';
import 'event_info_section.dart';

enum _EventDetailsTab { details, eligibility }

class EventDetailsTabs extends StatefulWidget {
  const EventDetailsTabs({super.key, required this.event});

  final EventDetails event;

  @override
  State<EventDetailsTabs> createState() => _EventDetailsTabsState();
}

class _EventDetailsTabsState extends State<EventDetailsTabs> {
  static const _switchDuration = Duration(milliseconds: 200);

  _EventDetailsTab _selected = _EventDetailsTab.details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final tab in _EventDetailsTab.values) ...[
              if (tab != _EventDetailsTab.values.first) SizedBox(width: AppSpacing.sm),
              _TabLabel(
                label: switch (tab) {
                  _EventDetailsTab.details => l10n.eventInfoTitle,
                  _EventDetailsTab.eligibility => l10n.eventEligibilityTitle,
                },
                isSelected: tab == _selected,
                onTap: () => setState(() => _selected = tab),
              ),
            ],
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        AnimatedSwitcher(
          duration: _switchDuration,
          layoutBuilder: (current, previous) =>
              Stack(alignment: AlignmentDirectional.topStart, children: [...previous, ?current]),
          child: KeyedSubtree(
            key: ValueKey(_selected),
            child: switch (_selected) {
              _EventDetailsTab.details => EventInfoSection(event: widget.event),
              _EventDetailsTab.eligibility => EventEligibilitySection(event: widget.event),
            },
          ),
        ),
      ],
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({required this.label, required this.isSelected, required this.onTap});

  static const _duration = Duration(milliseconds: 200);

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smRadius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: _duration,
              style: (context.textTheme.titleMedium ?? const TextStyle()).copyWith(
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              child: Text(label),
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
    );
  }
}
