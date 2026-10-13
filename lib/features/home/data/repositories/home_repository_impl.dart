import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../mappers/home_mapper.dart';

class HomeRepositoryImpl with RepositoryGuardMixin implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, HomeFeed>> loadFeed({
    required bool isMember,
    required DateTime day,
  }) async {
    final impactCall = isMember ? guard(_impact) : null;
    final slidesCall = guard(_slides);
    final tasksCall = isMember ? guard(_openTasks) : null;
    final featuredCall = guard(() => _featuredVolunteeringOpportunities(isMember: isMember));
    final dayCall = guard(() => _volunteeringOpportunitiesOn(day));
    final occasionsCall = _occasionsOn(day);
    final newsCall = guard(_news);

    final impact = await impactCall;
    final slides = await slidesCall;
    final tasks = await tasksCall;
    final featured = await featuredCall;
    final dayVolunteeringOpportunities = await dayCall;
    final occasions = await occasionsCall;
    final news = await newsCall;

    final results = <Either<Failure, Object>>[
      ?impact,
      slides,
      ?tasks,
      featured,
      dayVolunteeringOpportunities,
      news,
    ];
    if (results.every((result) => result.isLeft())) {
      return Left(results.first.fold((failure) => failure, (_) => const UnexpectedFailure('')));
    }

    return Right(
      HomeFeed(
        impact: impact?.fold((_) => null, (value) => value),
        slides: slides.getOrElse(() => const []),
        openTasks: tasks?.getOrElse(() => const []) ?? const [],
        featuredVolunteeringOpportunities: featured.getOrElse(() => const []),
        dayVolunteeringOpportunities: dayVolunteeringOpportunities.getOrElse(() => const []),
        dayOccasions: occasions,
        news: news.getOrElse(() => const []),
      ),
    );
  }

  @override
  Future<Either<Failure, HomeDayAgenda>> loadDay(DateTime day) async {
    final volunteeringOpportunitiesCall = guard(() => _volunteeringOpportunitiesOn(day));
    final occasionsCall = _occasionsOn(day);

    final volunteeringOpportunities = await volunteeringOpportunitiesCall;
    final occasions = await occasionsCall;

    return volunteeringOpportunities.map(
      (items) => HomeDayAgenda(volunteeringOpportunities: items, occasions: occasions),
    );
  }

  Future<List<HomeOccasion>> _occasionsOn(DateTime day) async {
    final result = await guard(() async {
      final occasions = await _remoteDataSource.getOccasionsOn(day);
      return occasions.map((occasion) => occasion.toEntity()).nonNulls.toList();
    });
    return result.getOrElse(() => const []);
  }

  Future<HomeImpact> _impact() async => (await _remoteDataSource.getProfile()).toEntity();

  Future<List<HomeSlide>> _slides() async {
    final slides = await _remoteDataSource.getSlides();
    final sorted = [...slides]..sort((a, b) => a.order.compareTo(b.order));
    return sorted
        .where((slide) => slide.imageUrl.isNotEmpty)
        .map((slide) => slide.toEntity())
        .toList();
  }

  Future<List<HomeTask>> _openTasks() async {
    final tasks = await _remoteDataSource.getAssignedTasks();
    final open = tasks.map((task) => task.toOpenTask()).nonNulls.toList()..sort(_compareByDue);
    return open;
  }

  static int _compareByDue(HomeTask a, HomeTask b) {
    final first = a.dueAt;
    final second = b.dueAt;
    if (first == null && second == null) return 0;
    if (first == null) return 1;
    if (second == null) return -1;
    return first.compareTo(second);
  }

  Future<List<HomeVolunteeringOpportunity>> _featuredVolunteeringOpportunities({
    required bool isMember,
  }) async {
    final volunteeringOpportunities = isMember
        ? await _remoteDataSource.getSuggestedVolunteeringOpportunities()
        : await _remoteDataSource.getUpcomingVolunteeringOpportunities();
    return volunteeringOpportunities
        .map((volunteeringOpportunity) => volunteeringOpportunity.toEntity())
        .nonNulls
        .toList();
  }

  Future<List<HomeVolunteeringOpportunity>> _volunteeringOpportunitiesOn(DateTime day) async {
    final volunteeringOpportunities = await _remoteDataSource.getVolunteeringOpportunitiesOn(day);
    return volunteeringOpportunities
        .map((volunteeringOpportunity) => volunteeringOpportunity.toEntity())
        .nonNulls
        .toList();
  }

  Future<List<HomeNews>> _news() async {
    final news = await _remoteDataSource.getLatestNews();
    return news.map((item) => item.toEntity()).nonNulls.toList();
  }
}
