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

class NewsSearchCard extends StatelessWidget {
  const NewsSearchCard({super.key, required this.result});

  final NewsSearchResult result;

  @override
  Widget build(BuildContext context) {
    final thumbnailSize = AppSizes.compactThumbnailSize;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => context.push(AppRoutes.newsDetailsPath(result.id)),
        borderRadius: AppRadius.mdRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.mdRadius,
                child: SizedBox.square(
                  dimension: thumbnailSize,
                  child: AppNetworkImage(url: result.imageUrl, size: thumbnailSize / 2),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.title(context.isArabic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                    NewsDateText(date: result.date),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
