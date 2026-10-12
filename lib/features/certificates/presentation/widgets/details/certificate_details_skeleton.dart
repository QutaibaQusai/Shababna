import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class CertificateDetailsSkeleton extends StatelessWidget {
  const CertificateDetailsSkeleton({super.key});

  static const _infoRowCount = 5;
  static const _buttonCount = 2;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          Center(
            child: Bone(
              width: AppSizes.avatarSize,
              height: AppSizes.avatarSize,
              borderRadius: AppRadius.mdRadius,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          const Center(child: Bone.text(words: 4)),
          SizedBox(height: AppSpacing.xxs),
          const Center(child: Bone.text(words: 2)),
          SizedBox(height: AppSpacing.md),
          const Bone.text(words: 2),
          for (var i = 0; i < _infoRowCount; i++) ...[
            SizedBox(height: AppSpacing.sm),
            const Bone.text(words: 6),
          ],
          SizedBox(height: AppSpacing.md),
          const Bone.text(words: 2),
          for (var i = 0; i < _buttonCount; i++) ...[
            SizedBox(height: AppSpacing.xs),
            Bone(height: AppSizes.buttonHeight, borderRadius: AppRadius.mdRadius),
          ],
        ],
      ),
    );
  }
}
