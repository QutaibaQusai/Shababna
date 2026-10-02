import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../domain/repositories/events_repository.dart';
import 'event_details_content.dart';

class EventDetailsSkeleton extends StatelessWidget {
  const EventDetailsSkeleton({super.key});

  static final _placeholder = EventDetails(
    id: 'placeholder',
    titleEn: 'Community health awareness day in Amman',
    titleAr: 'يوم التوعية الصحية المجتمعية في عمّان',
    descriptionEn:
        '<p>Join our volunteers for a day of health awareness activities with families in the community.</p>',
    descriptionAr: '<p>انضم إلى متطوعينا في يوم من أنشطة التوعية الصحية مع العائلات في المجتمع.</p>',
    type: const EventReference(id: 'placeholder', name: 'Awareness campaign'),
    from: DateTime(2026, 10, 12),
    to: DateTime(2026, 10, 14),
    address: 'Amman, Jordan',
    gender: EventGender.both,
    ageFrom: 16,
    ageTo: 30,
    hours: 6,
    activitiesCount: 3,
    volunteersCount: 20,
    requiresApproval: false,
    nationalities: const [],
    cities: const [],
    educations: const [],
    imageUrl: '',
    registrationStatus: EventRegistrationStatus.notRegistered,
    donors: const [],
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: IgnorePointer(child: EventDetailsContent(event: _placeholder)),
    );
  }
}
