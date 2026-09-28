import 'package:flutter/material.dart';

import '../../../../../core/config/app_assets.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/news_repository.dart';
import '../shared/news_date_text.dart';

class NewsDetailsHeader extends StatelessWidget {
  const NewsDetailsHeader({super.key, required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                AppAssets.logoIcon,
                width: AppSizes.iconMd,
                height: AppSizes.iconMd,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            NewsDateText(date: article.date),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          article.title(context.isArabic),
          style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
