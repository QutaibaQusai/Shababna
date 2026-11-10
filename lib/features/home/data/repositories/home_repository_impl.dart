import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../mappers/home_mapper.dart';
import '../models/home_models.dart';

class HomeRepositoryImpl with RepositoryGuardMixin implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, HomeFeed>> loadFeed({
    required bool isMember,
    required List<DateTime> days,
  }) async {
    final impactCall = isMember ? guard(_impact) : null;
    final slidesCall = guard(_slides);
    final tasksCall = isMember ? guard(_openTasks) : null;
    final suggestedCall = isMember ? guard(_suggested) : null;
    final upcomingCall = guard(_upcoming);
    final occasionsCall = _occasionsByDay(days);
    final newsCall = guard(_news);

    final impact = await impactCall;
    final slides = await slidesCall;
    final tasks = await tasksCall;
    final suggested = await suggestedCall;
    final upcoming = await upcomingCall;
    final occasions = await occasionsCall;
    final news = await newsCall;

    final results = <Either<Failure, Object>>[
      ?impact,
      slides,
      ?tasks,
      ?suggested,
      upcoming,
      occasions,
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
        suggestedVolunteeringOpportunities: suggested?.getOrElse(() => const []) ?? const [],
        upcomingVolunteeringOpportunities: upcoming.getOrElse(() => const []),
        occasionsByDay: occasions.getOrElse(() => const {}),
        news: news.getOrElse(() => const []),
      ),
    );
  }

  Future<Either<Failure, Map<DateTime, List<HomeOccasion>>>> _occasionsByDay(
    List<DateTime> days,
  ) async {
    final results = await Future.wait([for (final day in days) guard(() => _occasionsOn(day))]);
    if (results.isNotEmpty && results.every((result) => result.isLeft())) {
      return Left(results.first.fold((failure) => failure, (_) => const UnexpectedFailure('')));
    }
    return Right({
      for (var i = 0; i < days.length; i++)
        if (results[i].isRight()) days[i]: results[i].getOrElse(() => const []),
    });
  }

  Future<List<HomeOccasion>> _occasionsOn(DateTime day) async {
    final occasions = await _remoteDataSource.getOccasionsOn(day);
    return occasions.map((occasion) => occasion.toEntity()).nonNulls.toList();
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

  Future<List<HomeVolunteeringOpportunity>> _suggested() async =>
      _toEntities(await _remoteDataSource.getSuggestedVolunteeringOpportunities());

  Future<List<HomeVolunteeringOpportunity>> _upcoming() async =>
      _toEntities(await _remoteDataSource.getUpcomingVolunteeringOpportunities());

  static List<HomeVolunteeringOpportunity> _toEntities(
    List<HomeVolunteeringOpportunityModel> volunteeringOpportunities,
  ) {
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
