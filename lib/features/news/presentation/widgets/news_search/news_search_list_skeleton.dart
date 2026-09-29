import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/news_repository.dart';
import 'news_search_card.dart';

class NewsSearchListSkeleton extends StatelessWidget {
  const NewsSearchListSkeleton({super.key});

  static const _placeholderCount = 8;

  static final _placeholder = NewsSearchResult(
    id: 'placeholder',
    titleEn: 'Shababna volunteers plant trees across the kingdom',
    titleAr: 'متطوعو شبابنا يزرعون الأشجار في أنحاء المملكة',
    date: DateTime(2026),
    imageUrl: '',
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        itemCount: _placeholderCount,
        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.xs),
        itemBuilder: (context, index) => NewsSearchCard(result: _placeholder),
      ),
    );
  }
}
