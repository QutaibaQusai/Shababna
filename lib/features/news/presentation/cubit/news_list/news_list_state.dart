import 'package:equatable/equatable.dart';

import '../../../domain/repositories/news_repository.dart';

enum NewsListStatus { initial, loading, success, failure }

class NewsListState extends Equatable {
  const NewsListState({
    this.status = NewsListStatus.initial,
    this.items = const [],
    this.page = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.errorMessage,
  });

  final NewsListStatus status;
  final List<NewsArticle> items;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? errorMessage;

  bool get canLoadMore =>
      status == NewsListStatus.success && hasNextPage && !isLoadingMore && !loadMoreFailed;

  NewsListState copyWith({
    NewsListStatus? status,
    List<NewsArticle>? items,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? errorMessage,
  }) {
    return NewsListState(
      status: status ?? this.status,
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
        items,
        page,
        hasNextPage,
        isLoadingMore,
        loadMoreFailed,
        errorMessage,
      ];
}
