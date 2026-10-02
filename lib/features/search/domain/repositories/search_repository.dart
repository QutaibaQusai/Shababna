import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

enum SearchCategory { events, news, faq }

enum SearchEventTimeline { upcoming, ongoing, past }

class SearchEventResult extends Equatable {
  const SearchEventResult({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.typeNameEn,
    required this.typeNameAr,
    required this.from,
    required this.to,
    required this.timeline,
    required this.imageUrl,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String typeNameEn;
  final String typeNameAr;
  final DateTime from;
  final DateTime to;
  final SearchEventTimeline timeline;
  final String imageUrl;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  String typeName(bool isArabic) => isArabic ? typeNameAr : typeNameEn;

  @override
  List<Object?> get props =>
      [id, titleEn, titleAr, typeNameEn, typeNameAr, from, to, timeline, imageUrl];
}

class SearchNewsResult extends Equatable {
  const SearchNewsResult({
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

class SearchFaqResult extends Equatable {
  const SearchFaqResult({
    required this.id,
    required this.topicId,
    required this.topicNameEn,
    required this.topicNameAr,
    required this.questionEn,
    required this.questionAr,
  });

  final String id;
  final String topicId;
  final String topicNameEn;
  final String topicNameAr;
  final String questionEn;
  final String questionAr;

  String topicName(bool isArabic) => isArabic ? topicNameAr : topicNameEn;

  String question(bool isArabic) => isArabic ? questionAr : questionEn;

  @override
  List<Object?> get props => [id, topicId, topicNameEn, topicNameAr, questionEn, questionAr];
}

class SearchGroup<T> extends Equatable {
  const SearchGroup({required this.items, required this.hasMore});

  const SearchGroup.empty()
      : items = const [],
        hasMore = false;

  final List<T> items;
  final bool hasMore;

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [items, hasMore];
}

class GlobalSearchResults extends Equatable {
  const GlobalSearchResults({required this.events, required this.news, required this.faq});

  const GlobalSearchResults.empty()
      : events = const SearchGroup.empty(),
        news = const SearchGroup.empty(),
        faq = const SearchGroup.empty();

  final SearchGroup<SearchEventResult> events;
  final SearchGroup<SearchNewsResult> news;
  final SearchGroup<SearchFaqResult> faq;

  bool get isEmpty => events.isEmpty && news.isEmpty && faq.isEmpty;

  bool hasMore(SearchCategory category) => switch (category) {
        SearchCategory.events => events.hasMore,
        SearchCategory.news => news.hasMore,
        SearchCategory.faq => faq.hasMore,
      };

  @override
  List<Object?> get props => [events, news, faq];
}

abstract interface class SearchRepository {
  Future<Either<Failure, GlobalSearchResults>> search({
    required String query,
    required Set<SearchCategory> categories,
    required int perType,
  });
}
