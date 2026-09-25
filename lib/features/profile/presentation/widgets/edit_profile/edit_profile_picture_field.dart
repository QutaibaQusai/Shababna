import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/storage/secure_storage.dart';
import '../../../../../core/storage/storage_keys.dart';
import '../../../../../core/theme/app_sizes.dart';

class EditProfilePictureField extends StatelessWidget {
  const EditProfilePictureField({
    super.key,
    required this.hasPicture,
    this.pictureUrl,
    required this.onTap,
  });

  final bool hasPicture;
  final String? pictureUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.avatarSize * 1.8;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipOval(
              child: Container(
                width: size,
                height: size,
                color: context.colorScheme.surface,
                child: hasPicture && pictureUrl != null
                    ? _AuthenticatedImage(url: pictureUrl!, size: size)
                    : Icon(
                        LucideIcons.user,
                        size: size / 2,
                        color: context.colorScheme.onSurfaceVariant,
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
                  LucideIcons.pencilLine,
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

class _AuthenticatedImage extends StatelessWidget {
  const _AuthenticatedImage({required this.url, required this.size});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: sl<AppSecureStorage>().read(StorageKeys.accessToken),
      builder: (context, snapshot) {
        final token = snapshot.data;
        if (token == null) {
          return Icon(
            LucideIcons.user,
            size: size / 2,
            color: context.colorScheme.onSurfaceVariant,
          );
        }

        return CachedNetworkImage(
          imageUrl: url,
          httpHeaders: {'Authorization': 'Bearer $token'},
          fit: BoxFit.cover,
          width: size,
          height: size,
          placeholder: (context, url) => Icon(
            LucideIcons.user,
            size: size / 2,
            color: context.colorScheme.onSurfaceVariant,
          ),
          errorWidget: (context, url, error) => Icon(
            LucideIcons.user,
            size: size / 2,
            color: context.colorScheme.onSurfaceVariant,
          ),
        );
      },
    );
  }
}
