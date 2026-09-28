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

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final imageSize = AppSizes.listThumbnailSize;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => context.push(AppRoutes.newsDetailsPath(article.id)),
        borderRadius: AppRadius.lgRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title(isArabic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      article.summary(isArabic),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    NewsDateText(date: article.date),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              ClipRRect(
                borderRadius: AppRadius.xlRadius,
                child: SizedBox.square(
                  dimension: imageSize,
                  child: AppNetworkImage(url: article.imageUrl, size: imageSize / 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
