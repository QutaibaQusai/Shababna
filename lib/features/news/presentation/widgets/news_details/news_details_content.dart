import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/news_repository.dart';
import '../../mappers/news_media_mapper.dart';
import 'news_details_body.dart';
import 'news_details_header.dart';
import 'news_media_slider.dart';

class NewsDetailsContent extends StatelessWidget {
  const NewsDetailsContent({super.key, required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final margin = AppSpacing.screenMargin;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: margin),
          child: NewsDetailsHeader(article: article),
        ),
        SizedBox(height: AppSpacing.md),
        NewsMediaSlider(media: article.media),
        Padding(
          padding: EdgeInsets.all(margin),
          child: NewsDetailsBody(html: article.description(context.isArabic)),
        ),
      ],
    );
  }
}
