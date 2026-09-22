import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/profile_repository.dart';

String _initialsOf(String name) {
  final parts = name.split(' ').where((part) => part.isNotEmpty).toList();
  if (parts.isEmpty) return 'U';
  if (parts.length == 1) {
    return parts.first.length >= 2
        ? parts.first.substring(0, 2).toUpperCase()
        : parts.first.toUpperCase();
  }
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

class ProfileHeaderTile extends StatelessWidget {
  const ProfileHeaderTile({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final name = context.isArabic ? profile.fullNameAr : profile.fullNameEn;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenMargin,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _Avatar(
            name: name,
            url: profile.hasProfilePicture ? profile.profilePictureUrl : null,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  profile.email,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, required this.url});

  final String name;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.avatarSize,
      height: AppSizes.avatarSize,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: url == null ? _initials(context) : _image(context, url!),
    );
  }

  Widget _image(BuildContext context, String url) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: AppSizes.avatarSize,
        height: AppSizes.avatarSize,
        placeholder: (context, url) => _initials(context),
        errorWidget: (context, url, error) => _initials(context),
      ),
    );
  }

  Widget _initials(BuildContext context) {
    return Center(
      child: Text(
        _initialsOf(name),
        style: context.textTheme.titleLarge?.copyWith(
          color: context.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
