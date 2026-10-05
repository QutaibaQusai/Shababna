import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

class HomeSlide extends Equatable {
  const HomeSlide({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.imageUrl,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String imageUrl;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  String description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;

  @override
  List<Object?> get props => [id, titleEn, titleAr, descriptionEn, descriptionAr, imageUrl];
}

class HomeTier extends Equatable {
  const HomeTier({
    required this.name,
    required this.color,
    required this.lightIconUrl,
    required this.darkIconUrl,
  });

  final String name;
  final int color;
  final String lightIconUrl;
  final String darkIconUrl;

  String iconUrl({required bool isDark}) => isDark ? darkIconUrl : lightIconUrl;

  @override
  List<Object?> get props => [name, color, lightIconUrl, darkIconUrl];
}

class HomeImpact extends Equatable {
  const HomeImpact({
    required this.fullNameEn,
    required this.fullNameAr,
    required this.hours,
    required this.tier,
    required this.nextTier,
    required this.remainingHours,
    required this.progressPercentage,
  });

  final String fullNameEn;
  final String fullNameAr;
  final double hours;
  final HomeTier? tier;
  final HomeTier? nextTier;
  final double remainingHours;
  final int progressPercentage;

  String fullName(bool isArabic) {
    final preferred = isArabic ? fullNameAr : fullNameEn;
    return preferred.isNotEmpty ? preferred : (isArabic ? fullNameEn : fullNameAr);
  }

  @override
  List<Object?> get props => [
    fullNameEn,
    fullNameAr,
    hours,
    tier,
    nextTier,
    remainingHours,
    progressPercentage,
  ];
}

class HomeEvent extends Equatable {
  const HomeEvent({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.typeName,
    required this.from,
    required this.to,
    required this.imageUrl,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String typeName;
  final DateTime from;
  final DateTime to;
  final String imageUrl;

  String title(bool isArabic) => isArabic ? titleAr : titleEn;

  @override
  List<Object?> get props => [id, titleEn, titleAr, typeName, from, to, imageUrl];
}

class HomeNews extends Equatable {
  const HomeNews({
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

class HomeFeed extends Equatable {
  const HomeFeed({
    this.impact,
    this.slides = const [],
    this.openTasksCount = 0,
    this.featuredEvents = const [],
    this.dayEvents = const [],
    this.news = const [],
  });

  final HomeImpact? impact;
  final List<HomeSlide> slides;
  final int openTasksCount;
  final List<HomeEvent> featuredEvents;
  final List<HomeEvent> dayEvents;
  final List<HomeNews> news;

  HomeFeed withDayEvents(List<HomeEvent> events) => HomeFeed(
    impact: impact,
    slides: slides,
    openTasksCount: openTasksCount,
    featuredEvents: featuredEvents,
    dayEvents: events,
    news: news,
  );

  @override
  List<Object?> get props => [impact, slides, openTasksCount, featuredEvents, dayEvents, news];
}

abstract interface class HomeRepository {
  Future<Either<Failure, HomeFeed>> loadFeed({required bool isMember, required DateTime day});

  Future<Either<Failure, List<HomeEvent>>> eventsOn(DateTime day);
}
