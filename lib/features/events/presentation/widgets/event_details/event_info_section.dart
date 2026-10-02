import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/events_repository.dart';
import '../shared/event_date_range.dart';

class EventInfoSection extends StatelessWidget {
  const EventInfoSection({super.key, required this.event});

  final EventDetails event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tiles = [
      _InfoTile(
        icon: LucideIcons.calendarDays,
        text: eventDateRange(context, event.from, event.to),
      ),
      if (event.address.isNotEmpty) _InfoTile(icon: LucideIcons.mapPin, text: event.address),
      _InfoTile(icon: LucideIcons.clock, text: l10n.eventHours(event.hours)),
      if (event.volunteersCount > 0)
        _InfoTile(icon: LucideIcons.users, text: l10n.eventVolunteers(event.volunteersCount)),
      if (event.activitiesCount > 0)
        _InfoTile(icon: LucideIcons.listChecks, text: l10n.eventActivities(event.activitiesCount)),
    ];

    return Column(
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.xs),
          tiles[i],
        ],
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.text});

  static const _tintAlpha = 0.1;

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: primary.withValues(alpha: _tintAlpha),
            borderRadius: AppRadius.mdRadius,
          ),
          child: SizedBox.square(
            dimension: AppSizes.iconButtonSize,
            child: Icon(icon, size: AppSizes.iconField, color: primary),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text, style: context.textTheme.bodyMedium)),
      ],
    );
  }
}
