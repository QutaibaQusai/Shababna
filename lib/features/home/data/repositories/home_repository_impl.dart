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
    final slidesCall = isMember ? guard(_slides) : null;
    final tasksCall = isMember ? guard(_openTasksCount) : null;
    final featuredCall = guard(() => _featuredEvents(isMember: isMember));
    final dayCall = guard(() => _eventsOn(day));
    final newsCall = guard(_news);

    final impact = await impactCall;
    final slides = await slidesCall;
    final tasks = await tasksCall;
    final featured = await featuredCall;
    final dayEvents = await dayCall;
    final news = await newsCall;

    final results = <Either<Failure, Object>>[?impact, ?slides, ?tasks, featured, dayEvents, news];
    if (results.every((result) => result.isLeft())) {
      return Left(results.first.fold((failure) => failure, (_) => const UnexpectedFailure('')));
    }

    return Right(
      HomeFeed(
        impact: impact?.fold((_) => null, (value) => value),
        slides: slides?.getOrElse(() => const []) ?? const [],
        openTasksCount: tasks?.getOrElse(() => 0) ?? 0,
        featuredEvents: featured.getOrElse(() => const []),
        dayEvents: dayEvents.getOrElse(() => const []),
        news: news.getOrElse(() => const []),
      ),
    );
  }

  @override
  Future<Either<Failure, List<HomeEvent>>> eventsOn(DateTime day) => guard(() => _eventsOn(day));

  Future<HomeImpact> _impact() async => (await _remoteDataSource.getProfile()).toEntity();

  Future<List<HomeSlide>> _slides() async {
    final slides = await _remoteDataSource.getSlides();
    final sorted = [...slides]..sort((a, b) => a.order.compareTo(b.order));
    return sorted
        .where((slide) => slide.imageUrl.isNotEmpty)
        .map((slide) => slide.toEntity())
        .toList();
  }

  Future<int> _openTasksCount() async {
    final tasks = await _remoteDataSource.getAssignedTasks();
    return tasks.where((task) => task.isOpen).length;
  }

  Future<List<HomeEvent>> _featuredEvents({required bool isMember}) async {
    final events = isMember
        ? await _remoteDataSource.getSuggestedEvents()
        : await _remoteDataSource.getUpcomingEvents();
    return events.map((event) => event.toEntity()).nonNulls.toList();
  }

  Future<List<HomeEvent>> _eventsOn(DateTime day) async {
    final events = await _remoteDataSource.getEventsOn(day);
    return events.map((event) => event.toEntity()).nonNulls.toList();
  }

  Future<List<HomeNews>> _news() async {
    final news = await _remoteDataSource.getLatestNews();
    return news.map((item) => item.toEntity()).nonNulls.toList();
  }
}
