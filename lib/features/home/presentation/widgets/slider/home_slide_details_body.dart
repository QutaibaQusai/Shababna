import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/views/media_viewer/app_media.dart';
import '../../../../../core/shared/views/media_viewer/show_media_browser.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/home_repository.dart';
import '../shared/home_authorized_image.dart';
import 'home_banner_carousel.dart';

class HomeSlideDetailsBody extends StatelessWidget {
  const HomeSlideDetailsBody({super.key, required this.slide});

  final HomeSlide slide;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final title = slide.title(isArabic).trim();
    final description = slide.description(isArabic).trim();

    return ListView(
      padding: EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        GestureDetector(
          onTap: () => showMediaBrowser(context, media: [AppImageMedia(slide.imageUrl)]),
          child: Hero(
            tag: HomeBannerCarousel.heroTag(slide.id),
            child: ClipRRect(
              borderRadius: AppRadius.lgRadius,
              child: AspectRatio(
                aspectRatio: HomeBannerCarousel.aspectRatio,
                child: HomeAuthorizedImage(url: slide.imageUrl),
              ),
            ),
          ),
        ),
        if (title.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
        if (description.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
