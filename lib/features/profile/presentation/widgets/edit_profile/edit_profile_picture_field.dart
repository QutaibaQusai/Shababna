import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../shared/profile_avatar.dart';

class EditProfilePictureField extends StatelessWidget {
  const EditProfilePictureField({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.cacheKey,
    required this.onTap,
    this.localFilePath,
    this.isBusy = false,
  });

  final String name;
  final String? imageUrl;
  final String? cacheKey;
  final String? localFilePath;
  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.avatarSize * 1.8;

    return Center(
      child: GestureDetector(
        onTap: isBusy ? null : onTap,
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
            PositionedDirectional(
              bottom: 0,
              end: 0,
              child: Container(
                width: AppSizes.profileBadgeSize,
                height: AppSizes.profileBadgeSize,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colorScheme.surface, width: 2),
                ),
                child: Icon(
                  LucideIcons.camera,
                  size: AppSizes.iconSm,
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
