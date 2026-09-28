import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/news_repository.dart';
import 'news_card.dart';

class NewsListSkeleton extends StatelessWidget {
  const NewsListSkeleton({super.key});

  static const _placeholderCount = 3;

  static final _placeholder = NewsArticle(
    id: 'placeholder',
    titleEn: 'Shababna volunteers plant trees across the kingdom',
    titleAr: 'متطوعو شبابنا يزرعون الأشجار في أنحاء المملكة',
    descriptionEn: '',
    descriptionAr: '',
    summaryEn: 'More than two hundred volunteers spent the weekend restoring green areas together.',
    summaryAr: 'أمضى أكثر من مئتي متطوع عطلة نهاية الأسبوع في إعادة تأهيل المساحات الخضراء معاً.',
    date: DateTime(2026),
    imageUrl: '',
    images: const [],
    videos: const [],
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        itemCount: _placeholderCount,
        separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => NewsCard(article: _placeholder),
      ),
    );
  }
}
