import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/news_repository.dart';
import '../shared/news_date_text.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.article});

  static const _imageAspectRatio = 16 / 9;

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;

    return Material(
      color: context.colorScheme.surface,
      borderRadius: AppRadius.lgRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.newsDetailsPath(article.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: _imageAspectRatio,
              child: AppNetworkImage(url: article.imageUrl, size: AppSizes.iconLg * 2),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NewsDateText(date: article.date),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    article.title(isArabic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    article.summary(isArabic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
