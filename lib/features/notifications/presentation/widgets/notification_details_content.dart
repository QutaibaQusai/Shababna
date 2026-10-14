import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_network_image.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationDetailsContent extends StatelessWidget {
  const NotificationDetailsContent({super.key, required this.notification});

  static const _imageAspectRatio = 16 / 9;
  static const _bodyLineHeight = 1.6;

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final imageUrl = notification.imageUrl;
    final body = notification.body(isArabic);

    return ListView(
      padding: EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        Text(
          notification.title(isArabic),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (imageUrl != null) ...[
          SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadius.lgRadius,
            child: AspectRatio(
              aspectRatio: _imageAspectRatio,
              child: AppNetworkImage(url: imageUrl, size: AppSizes.iconLg),
            ),
          ),
        ],
        if (body.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: context.textTheme.bodyLarge?.copyWith(
              height: _bodyLineHeight,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
