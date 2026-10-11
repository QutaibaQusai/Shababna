import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../shared/profile_avatar.dart';
import 'tier_arc_frame.dart';

class EditProfilePictureField extends StatelessWidget {
  const EditProfilePictureField({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.cacheKey,
    required this.onTap,
    this.localFilePath,
    this.isBusy = false,
    this.tier,
    this.nextTier,
    this.tierPercentage = 0,
  });

  final String name;
  final String? imageUrl;
  final String? cacheKey;
  final String? localFilePath;
  final bool isBusy;
  final VoidCallback onTap;
  final VolunteerTier? tier;
  final NextVolunteerTier? nextTier;
  final int tierPercentage;

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.avatarSize * 1.8;
    final onPressed = isBusy ? null : onTap;
    final hasPicture = imageUrl != null || localFilePath != null;

    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: TierArcFrame(
            tier: tier,
            nextTier: nextTier,
            percentage: tierPercentage,
            childSize: size,
            child: _avatar(context, size),
          ),
        ),
        SizedBox(height: AppSpacing.xxs),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(hasPicture ? context.l10n.changePhotoButton : context.l10n.addPhotoButton),
        ),
      ],
    );
  }

  Widget _avatar(BuildContext context, double size) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ProfileAvatar(
            name: name,
            size: size,
            imageUrl: imageUrl,
            cacheKey: cacheKey,
            localFilePath: localFilePath,
          ),
          if (isBusy)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.scrim.withValues(alpha: 0.45),
                ),
                child: Center(
                  child: SizedBox(
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
