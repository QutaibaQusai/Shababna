import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationPreferencesSkeleton extends StatelessWidget {
  const NotificationPreferencesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final _ in NotificationPreference.values)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Bone.text(words: 2),
                  SizedBox(height: AppSpacing.xxs),
                  const Bone.text(words: 5),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
