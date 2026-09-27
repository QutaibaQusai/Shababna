import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';

class NewsArticle extends Equatable {
  const NewsArticle({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.summaryEn,
    required this.summaryAr,
    required this.date,
    required this.imageUrl,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String summaryEn;
  final String summaryAr;
  final DateTime? date;
  final String? imageUrl;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  String description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;

  String summary(bool isArabic) => isArabic ? summaryAr : summaryEn;

  @override
  List<Object?> get props => [id];
}

abstract interface class NewsRepository {
  Future<Either<Failure, PagedResult<NewsArticle>>> getNews({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, NewsArticle>> getNewsById(String id);
}
