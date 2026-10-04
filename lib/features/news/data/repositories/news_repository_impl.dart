import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';
import '../mappers/news_mapper.dart';

class NewsRepositoryImpl with RepositoryGuardMixin implements NewsRepository {
  NewsRepositoryImpl(this._remoteDataSource);

  final NewsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PagedResult<NewsSummary>>> getNews({
    required int page,
    required int pageSize,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.getNews(page: page, pageSize: pageSize);
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
  Future<Either<Failure, PagedResult<NewsSearchResult>>> searchNews({
    required String query,
    required int page,
    required int pageSize,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.searchNews(
        query: query,
        page: page,
        pageSize: pageSize,
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
  Future<Either<Failure, NewsArticle>> getNewsById(String id) {
    return guard(() async {
      final response = await _remoteDataSource.getNewsById(id);
      return response.toEntity();
    });
  }
}
