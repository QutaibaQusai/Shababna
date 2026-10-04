import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_remote_data_source.dart';
import '../mappers/events_mapper.dart';

class EventsRepositoryImpl with RepositoryGuardMixin implements EventsRepository {
  EventsRepositoryImpl(this._remoteDataSource);

  final EventsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PagedResult<EventSummary>>> getEvents({
    required int page,
    required int pageSize,
    String? typeId,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.getEvents(
        page: page,
        pageSize: pageSize,
        typeId: typeId,
      );
      return PagedResult(
        items: response.items.map((item) => item.toEntity()).toList(),
        page: response.page,
        pageSize: response.pageSize,
        totalCount: response.totalCount,
        hasNextPage: response.hasNextPage,
      );
    });
  }

  @override
  Future<Either<Failure, List<EventType>>> getEventTypes() {
    return guard(() async => (await _remoteDataSource.getEventTypes()).toEntities());
  }

  @override
  Future<Either<Failure, EventDetails>> getEventById(String id) {
    return guard(() async {
      final response = await _remoteDataSource.getEventById(id);
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, EventRegistrationResult>> register(
    String id, {
    required String idempotencyKey,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.register(id, idempotencyKey: idempotencyKey);
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, EventRegistrationResult>> withdraw(String id) {
    return guard(() async {
      final response = await _remoteDataSource.withdraw(id);
      return response.toEntity();
    });
  }
}
