import 'package:equatable/equatable.dart';

import '../../../domain/repositories/news_repository.dart';

enum NewsSearchStatus { idle, loading, success, failure }

class NewsSearchState extends Equatable {
  const NewsSearchState({
    this.status = NewsSearchStatus.idle,
    this.query = '',
    this.items = const [],
    this.page = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.errorMessage,
  });

  final NewsSearchStatus status;
  final String query;
  final List<NewsSearchResult> items;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? errorMessage;

  bool get canLoadMore =>
      status == NewsSearchStatus.success && hasNextPage && !isLoadingMore && !loadMoreFailed;

  NewsSearchState copyWith({
    NewsSearchStatus? status,
    String? query,
    List<NewsSearchResult>? items,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? errorMessage,
  }) {
    return NewsSearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      items: items ?? this.items,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        query,
        items,
        page,
        hasNextPage,
        isLoadingMore,
        loadMoreFailed,
        errorMessage,
      ];
}
