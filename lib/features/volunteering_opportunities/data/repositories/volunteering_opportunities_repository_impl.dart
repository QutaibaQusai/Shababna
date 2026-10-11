import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';
import '../../domain/repositories/volunteering_opportunities_repository.dart';
import '../datasources/volunteering_opportunities_remote_data_source.dart';
import '../mappers/volunteering_opportunities_mapper.dart';

class VolunteeringOpportunitiesRepositoryImpl
    with RepositoryGuardMixin
    implements VolunteeringOpportunitiesRepository {
  VolunteeringOpportunitiesRepositoryImpl(this._remoteDataSource);

  final VolunteeringOpportunitiesRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PagedResult<VolunteeringOpportunitySummary>>>
  getVolunteeringOpportunities({
    required int page,
    required int pageSize,
    String? typeId,
    DateTime? date,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.getVolunteeringOpportunities(
        page: page,
        pageSize: pageSize,
        typeId: typeId,
        date: date,
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
  Future<Either<Failure, List<VolunteeringOpportunityType>>> getVolunteeringOpportunityTypes() {
    return guard(
      () async => (await _remoteDataSource.getVolunteeringOpportunityTypes()).toEntities(),
    );
  }

  @override
  Future<Either<Failure, VolunteeringOpportunityDetails>> getVolunteeringOpportunityById(
    String id,
  ) {
    return guard(() async {
      final response = await _remoteDataSource.getVolunteeringOpportunityById(id);
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, VolunteeringOpportunityRegistrationResult>> register(
    String id, {
    required String idempotencyKey,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.register(id, idempotencyKey: idempotencyKey);
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, VolunteeringOpportunityRegistrationResult>> withdraw(String id) {
    return guard(() async {
      final response = await _remoteDataSource.withdraw(id);
      return response.toEntity();
    });
  }
}
