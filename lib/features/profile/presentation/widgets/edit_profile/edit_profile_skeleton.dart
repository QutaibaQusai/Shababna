import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

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
              child: CircleAvatar(
                radius: AppSizes.avatarSize * 0.9,
                backgroundColor: context.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            const _FieldBone(),
            SizedBox(height: AppSpacing.sm),
            const _CardBone(),
            SizedBox(height: AppSpacing.sm),
            const _CardBone(),
            SizedBox(height: AppSpacing.md),
            Text(context.l10n.genderLabel, style: context.textTheme.titleSmall),
            SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(child: _OptionBone()),
                SizedBox(width: AppSpacing.xs),
                Expanded(child: _OptionBone()),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            const _FieldBone(),
            SizedBox(height: AppSpacing.sm),
            const _FieldBone(),
            SizedBox(height: AppSpacing.sm),
            const _FieldBone(),
          ],
        ),
      ),
    );
  }
}

class _FieldBone extends StatelessWidget {
  const _FieldBone();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Label',
          style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
        SizedBox(height: AppSpacing.xxs),
        Container(
          height: AppSizes.buttonHeight,
          decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.outlineVariant),
            borderRadius: AppRadius.mdRadius,
          ),
        ),
      ],
    );
  }
}

class _OptionBone extends StatelessWidget {
  const _OptionBone();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.buttonHeight,
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.outlineVariant),
        borderRadius: AppRadius.mdRadius,
      ),
    );
  }
}

class _CardBone extends StatelessWidget {
  const _CardBone();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title', style: context.textTheme.titleSmall),
          SizedBox(height: AppSpacing.xxs),
          Text(
            'Subtitle placeholder text',
            style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            height: AppSizes.buttonHeight,
            decoration: BoxDecoration(
              border: Border.all(color: context.colorScheme.outlineVariant),
              borderRadius: AppRadius.mdRadius,
            ),
          ),
        ],
      ),
    );
  }
}
