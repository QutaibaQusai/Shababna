import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_spacing.dart';

class NotificationDetailsSkeleton extends StatelessWidget {
  const NotificationDetailsSkeleton({super.key});

  static const _bodyLines = 4;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const Bone.text(words: 4),
          SizedBox(height: AppSpacing.sm),
          const Bone.multiText(lines: _bodyLines),
        ],
      ),
    );
  }
}
