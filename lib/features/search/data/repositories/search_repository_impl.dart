import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';
import '../mappers/search_mapper.dart';

class SearchRepositoryImpl with RepositoryGuardMixin implements SearchRepository {
  SearchRepositoryImpl(this._remoteDataSource);

  final SearchRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, GlobalSearchResults>> search({
    required String query,
    required Set<SearchCategory> categories,
    required int perType,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.search(
        query: query,
        categories: categories,
        perType: perType,
      );
      return response.toEntity();
    });
  }
}
