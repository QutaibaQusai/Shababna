import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/home_repository.dart';
import '../shared/home_formatters.dart';
import '../shared/home_list_tile.dart';

class HomeNewsList extends StatelessWidget {
  const HomeNewsList({super.key, required this.news});

  final List<HomeNews> news;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;

    return Column(
      children: [
        for (var i = 0; i < news.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.xs),
          HomeListTile(
            imageUrl: news[i].imageUrl,
            title: news[i].title(isArabic),
            subtitle: news[i].summary(isArabic),
            meta: HomeFormatters.date(context, news[i].date),
            onTap: () => context.push(AppRoutes.newsDetailsPath(news[i].id)),
          ),
        ],
      ],
    );
  }
}
