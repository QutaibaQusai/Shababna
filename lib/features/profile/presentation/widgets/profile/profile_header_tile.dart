import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../shared/profile_avatar.dart';
import 'profile_completion_badge.dart';
import 'volunteer_tier_badge.dart';

class ProfileHeaderTile extends StatelessWidget {
  const ProfileHeaderTile({super.key, required this.profile, required this.pictureCacheKey});

  final Profile profile;
  final String? pictureCacheKey;

  @override
  Widget build(BuildContext context) {
    final name = profile.fullName(context.isArabic);
    final displayName = name.isEmpty ? context.l10n.defaultUserName : name;
    final tier = profile.tier;

    return InkWell(
      onTap: () => context.push(AppRoutes.editProfile),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.screenMargin,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            ProfileAvatar(
              name: name,
              size: AppSizes.avatarSize,
              imageUrl: profile.hasProfilePicture ? profile.profilePictureUrl : null,
              cacheKey: pictureCacheKey,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (tier != null) ...[
                        SizedBox(width: AppSpacing.xxs),
                        VolunteerTierBadge(
                          name: tier.name,
                          lightIconUrl: tier.lightIconUrl,
                          darkIconUrl: tier.darkIconUrl,
                          size: AppSizes.iconMd,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    profile.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            ProfileCompletionBadge(percentage: profile.completionPercentage),
          ],
        ),
      ),
    );
  }
}
