import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/search_repository.dart';
import 'global_search_state.dart';

class GlobalSearchCubit extends Cubit<GlobalSearchState> {
  GlobalSearchCubit(this._repository) : super(const GlobalSearchState());

  static const minQueryLength = 2;
  static const maxQueryLength = 100;
  static const _allPerType = 5;
  static const _categoryPerType = 20;
  static const _debounce = Duration(milliseconds: 400);
  static const _allCategories = {
    SearchCategory.volunteeringOpportunities,
    SearchCategory.news,
    SearchCategory.faq,
  };

  final SearchRepository _repository;
  Timer? _debounceTimer;
  int _requestToken = 0;

  void queryChanged(String text) {
    final query = _normalize(text);
    if (query == state.query) return;

    _debounceTimer?.cancel();
    _requestToken++;

    if (query.length < minQueryLength) {
      emit(GlobalSearchState(query: query, category: state.category));
      return;
    }

    emit(_loading(query, state.category));
    _debounceTimer = Timer(_debounce, () => _search(query, state.category));
  }

  void categorySelected(SearchCategory? category) {
    if (category == state.category) return;
    _debounceTimer?.cancel();
    _requestToken++;

    if (state.query.length < minQueryLength) {
      emit(GlobalSearchState(query: state.query, category: category));
      return;
    }

    emit(_loading(state.query, category));
    _search(state.query, category);
  }

  Future<void> retry() async {
    if (state.query.length < minQueryLength) return;
    _requestToken++;
    emit(_loading(state.query, state.category));
    await _search(state.query, state.category);
  }

  Future<void> _search(String query, SearchCategory? category) async {
    final token = _requestToken;
    final result = await _repository.search(
      query: query,
      categories: category == null ? _allCategories : {category},
      perType: category == null ? _allPerType : _categoryPerType,
    );
    if (isClosed || token != _requestToken) return;

    result.fold(
      (failure) => emit(GlobalSearchState(
        status: GlobalSearchStatus.failure,
        query: query,
        category: category,
        errorMessage: failure is UnexpectedFailure ? null : failure.displayMessage,
      )),
      (results) => emit(GlobalSearchState(
        status: GlobalSearchStatus.success,
        query: query,
        category: category,
        results: results,
      )),
    );
  }

  GlobalSearchState _loading(String query, SearchCategory? category) =>
      GlobalSearchState(status: GlobalSearchStatus.loading, query: query, category: category);

  String _normalize(String text) {
    final trimmed = text.trim();
    return trimmed.length > maxQueryLength ? trimmed.substring(0, maxQueryLength) : trimmed;
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
