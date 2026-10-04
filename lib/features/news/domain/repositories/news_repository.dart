import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';

class NewsImage extends Equatable {
  const NewsImage({required this.id, required this.url});

  final String id;
  final String url;

  @override
  List<Object?> get props => [id, url];
}

class NewsVideo extends Equatable {
  const NewsVideo({required this.id, required this.url, required this.isExternal});

  final String id;
  final String url;
  final bool isExternal;

  @override
  List<Object?> get props => [id, url, isExternal];
}

class NewsSummary extends Equatable {
  const NewsSummary({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.summaryEn,
    required this.summaryAr,
    required this.date,
    required this.imageUrl,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String summaryEn;
  final String summaryAr;
  final DateTime date;
  final String imageUrl;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  String summary(bool isArabic) => isArabic ? summaryAr : summaryEn;

  @override
  List<Object?> get props => [id, titleEn, titleAr, summaryEn, summaryAr, date, imageUrl];
}

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
    required this.images,
    required this.videos,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String summaryEn;
  final String summaryAr;
  final DateTime date;
  final String imageUrl;
  final List<NewsImage> images;
  final List<NewsVideo> videos;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  String description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;

  String summary(bool isArabic) => isArabic ? summaryAr : summaryEn;

  @override
  List<Object?> get props => [
        id,
        titleEn,
        titleAr,
        descriptionEn,
        descriptionAr,
        date,
        imageUrl,
        images,
        videos,
      ];
}

class NewsSearchResult extends Equatable {
  const NewsSearchResult({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.date,
    required this.imageUrl,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final DateTime date;
  final String imageUrl;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  @override
  List<Object?> get props => [id, titleEn, titleAr, date, imageUrl];
}

abstract interface class NewsRepository {
  Future<Either<Failure, PagedResult<NewsSummary>>> getNews({
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, PagedResult<NewsSearchResult>>> searchNews({
    required String query,
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, NewsArticle>> getNewsById(String id);
}
