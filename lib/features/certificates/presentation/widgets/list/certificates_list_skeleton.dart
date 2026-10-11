import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class CertificatesListSkeleton extends StatelessWidget {
  const CertificatesListSkeleton({super.key});

  static const _cardAspectRatio = 4.5;
  static const _cardCount = 6;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const Bone.text(words: 2),
          SizedBox(height: AppSpacing.xs),
          const Bone.text(words: 5),
          for (var i = 0; i < _cardCount; i++) ...[
            SizedBox(height: i == 0 ? AppSpacing.md : AppSpacing.sm),
            AspectRatio(
              aspectRatio: _cardAspectRatio,
              child: Bone(borderRadius: AppRadius.lgRadius),
            ),
          ],
        ],
      ),
    );
  }
}
