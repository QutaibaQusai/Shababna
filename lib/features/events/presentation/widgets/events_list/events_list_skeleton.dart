import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/events_repository.dart';
import 'event_card.dart';

class EventsListSkeleton extends StatelessWidget {
  const EventsListSkeleton({super.key});

  static const _placeholderCount = 3;

  static final _placeholder = EventSummary(
    id: 'placeholder',
    titleEn: 'Community health awareness day in Amman',
    titleAr: 'يوم التوعية الصحية المجتمعية في عمّان',
    type: const EventReference(id: 'placeholder', name: 'Awareness campaign'),
    from: DateTime(2026, 10, 12),
    to: DateTime(2026, 10, 14),
    address: 'Amman, Jordan',
    gender: EventGender.both,
    ageFrom: 16,
    ageTo: 30,
    hours: 6,
    volunteersCount: 20,
    requiresApproval: false,
    imageUrl: '',
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        itemCount: _placeholderCount,
        separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) => EventCard(event: _placeholder),
      ),
    );
  }
}
