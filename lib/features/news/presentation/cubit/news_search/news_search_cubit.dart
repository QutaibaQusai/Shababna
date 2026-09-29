import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/news_repository.dart';
import 'news_search_state.dart';

class NewsSearchCubit extends Cubit<NewsSearchState> {
  NewsSearchCubit(this._repository) : super(const NewsSearchState());

  static const pageSize = 20;
  static const minQueryLength = 2;
  static const _debounce = Duration(milliseconds: 400);

  final NewsRepository _repository;
  Timer? _debounceTimer;
  int _requestToken = 0;

  void queryChanged(String text) {
    final query = text.trim();
    if (query == state.query) return;

    _debounceTimer?.cancel();
    _requestToken++;

    if (query.length < minQueryLength) {
      emit(NewsSearchState(query: query));
      return;
    }

    emit(NewsSearchState(status: NewsSearchStatus.loading, query: query));
    _debounceTimer = Timer(_debounce, () => _searchFirstPage(query));
  }

  Future<void> retry() async {
    if (state.query.length < minQueryLength) return;
    _requestToken++;
    emit(NewsSearchState(status: NewsSearchStatus.loading, query: state.query));
    await _searchFirstPage(state.query);
  }

  Future<void> loadMore() async {
    if (!state.canLoadMore) return;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final token = _requestToken;
    final nextPage = state.page + 1;
    final result = await _repository.searchNews(
      query: state.query,
      page: nextPage,
      pageSize: pageSize,
    );
    if (isClosed || token != _requestToken) return;

    result.fold(
      (_) => emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true)),
      (paged) => emit(state.copyWith(
        items: [...state.items, ...paged.items],
        page: nextPage,
        hasNextPage: paged.hasNextPage,
        isLoadingMore: false,
      )),
    );
  }

  Future<void> retryLoadMore() {
    emit(state.copyWith(loadMoreFailed: false));
    return loadMore();
  }

  Future<void> _searchFirstPage(String query) async {
    final token = _requestToken;
    final result = await _repository.searchNews(query: query, page: 1, pageSize: pageSize);
    if (isClosed || token != _requestToken) return;

    result.fold(
      (failure) => emit(NewsSearchState(
        status: NewsSearchStatus.failure,
        query: query,
        errorMessage: failure is UnexpectedFailure ? null : failure.displayMessage,
      )),
      (paged) => emit(NewsSearchState(
        status: NewsSearchStatus.success,
        query: query,
        items: paged.items,
        page: 1,
        hasNextPage: paged.hasNextPage,
      )),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
