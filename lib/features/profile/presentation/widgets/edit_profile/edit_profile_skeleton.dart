import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'edit_profile_section_title.dart';

class EditProfileSkeleton extends StatelessWidget {
  const EditProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: AppSizes.avatarSize,
                height: AppSizes.avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.surface,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            _SectionBone(title: context.l10n.personalInfoSectionTitle, fieldCount: 8),
            SizedBox(height: AppSpacing.lg),
            _SectionBone(title: context.l10n.addressSectionTitle, fieldCount: 4),
            SizedBox(height: AppSpacing.lg),
            _SectionBone(title: context.l10n.volunteeringSectionTitle, fieldCount: 6),
            SizedBox(height: AppSpacing.lg),
            _SectionBone(title: context.l10n.documentsSectionTitle, fieldCount: 2),
          ],
        ),
      ),
    );
  }
}

class _SectionBone extends StatelessWidget {
  const _SectionBone({required this.title, required this.fieldCount});

  final String title;
  final int fieldCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileSectionTitle(title: title),
        SizedBox(height: AppSpacing.sm),
        for (var i = 0; i < fieldCount; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.sm),
          const _FieldBone(),
        ],
      ],
    );
  }
}

class _FieldBone extends StatelessWidget {
  const _FieldBone();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.buttonHeight,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.mdRadius,
      ),
    );
  }
}
